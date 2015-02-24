module Spree
  class PaypalAdaptiveController < StoreController
    ssl_allowed

    def adaptive
      order = current_order || raise(ActiveRecord::RecordNotFound)
      items = order.shipments.map(&method(:shipment))

      # Check if item amount <> 0 (required by PayPal)
      items.reject! do |item|
        item[:amount].zero?
      end
      items = request_details(items, order)
    
      pay = provider.build_pay(items)

      begin
        response = provider.pay(pay) 
        if response.success?
          redirect_to provider.payment_url(response)
        else
          flash[:error] = Spree.t('flash.generic_error', :scope => 'paypal_adaptive', 
                    :reasons => response.error[0].message)
          redirect_to checkout_state_path(:payment)
        end
      rescue SocketError
        flash[:error] = Spree.t('flash.connection_failed', :scope => 'paypal_adaptive')
        redirect_to checkout_state_path(:payment)
      end
    end

    def confirm
      order = current_order || raise(ActiveRecord::RecordNotFound)
      order.payments.create!({
        :source => Spree::PaypalAdaptiveCheckout.create({
          :pay_key => params[:payKey]
        }),
        :amount => order.total,
        :payment_method => payment_method
      })
      order.next
      if order.complete?
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        session[:order_id] = nil
        redirect_to completion_route(order)
      else
        redirect_to checkout_state_path(order.state)
      end
    end
    
    def cancel
      flash[:notice] = Spree.t('flash.cancel', :scope => 'paypal_adaptive')
      order = current_order || raise(ActiveRecord::RecordNotFound)
      redirect_to checkout_state_path(order.state, paypal_adaptive_cancel_token: params[:token])
    end

    private

    def payment_method
      Spree::PaymentMethod.find(params[:payment_method_id])
    end

    def provider
      payment_method.provider
    end

    def shipment(item)
      amount = 0
      item.line_items.each do |line_item|
        amount += line_item.price
        line_item.adjustments.each { |adjustment| amount += adjustment.amount }            
      end
      {
        :email => item.supplier.paypal_email,
        :amount => item.cost + amount,
        :paymentType => "GOODS",
        :invoiceId => item.order.number 
      }
    end

    def request_details(items, order)
      {
          :currencyCode => order.currency,
          :actionType => "PAY",
          :feesPayer => "SENDER",
          :reverseAllParallelPaymentsOnError => true,
          :returnUrl => confirm_paypal_adaptive_url(:payment_method_id => params[:payment_method_id], :utm_nooverride => 1)+"&payKey=${payKey}",
          :cancelUrl =>  cancel_paypal_adaptive_url,
          :receiverList => {
            :receiver => items
          }
      }
    end
  
    def completion_route(order)
      order_path(order, :token => order.guest_token)
    end
  
  end
end
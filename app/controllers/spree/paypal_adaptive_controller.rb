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
          render json: {
            paykey: response.payKey
          }.to_json
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
      payment_details = provider.build_payment_details({ :payKey => params[:payKey] })
      payment_details_response = provider.payment_details(payment_details)

      order = current_order || raise(ActiveRecord::RecordNotFound)

      if payment_details_response.success?
        payment_details_response.paymentInfoList.paymentInfo.each do |payment_item|
          order.payments.create!({
            :source => Spree::PaypalAdaptiveCheckout.create({
              :pay_key => params[:payKey],
              :receiver_email => payment_item.receiver.email,
              :transaction_id => payment_item.transactionId
            }),
            :amount => payment_item.receiver.amount,
            :payment_method => payment_method
          })
        end
      end

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
      render :close_flow, layout: false
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
        amount += line_item.price * line_item.quantity
        line_item.adjustments.each { |adjustment| amount += adjustment.amount }
      end
      {
        :email => ENV['jml_paypal_email'],
        :amount => item.order.total,
        :paymentType => "GOODS",
        :invoiceId => item.order.number
      }
    end

    def payment_attributes(item)
      {
         :source => Spree::PaypalAdaptiveCheckout.create({
            :pay_key => item.payKey,
            :receiver_email => item.receiver.email,
            :transaction_id => item.transactionId
          }),
          :amount => item.receiver.amount,
          :payment_method => payment_method
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

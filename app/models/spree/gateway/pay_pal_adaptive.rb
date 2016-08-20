require 'paypal-sdk-adaptivepayments'

module Spree
  class Gateway::PayPalAdaptive < Gateway
    preference :primary_email, :string
    preference :app_id, :string
    preference :login, :string
    preference :password, :string
    preference :signature, :string
    preference :server, :string, default: 'sandbox'

    def supports?(source)
      true
    end

    def provider_class
      PayPal::SDK::AdaptivePayments
    end

    def provider
      ::PayPal::SDK.configure(
        :mode      => preferred_server.present? ? preferred_server : "sandbox",
        :app_id    => preferred_app_id,
        :username  => preferred_login,
        :password  => preferred_password,
        :signature => preferred_signature)
      provider_class.new
    end

    def auto_capture?
      true
    end

    def method_type
      'paypal_adaptive'
    end

    def purchase(amount, adaptive_checkout, gateway_options={})
      Class.new do
        def success?; true; end
        def authorization; nil; end
      end.new
    end

    def credit arg1, arg2, arg3
      Class.new do
        def success?; true; end
        def authorization; nil; end
      end.new
    end

    def refund(payment, amount)
      refund_type = payment.amount == amount.to_f ? "Full" : "Partial"

      refund_transaction = provider.build_refund({
        :currencyCode => payment.currency,
        :payKey => payment.source.pay_key,
        :requestEnvelope => {
          :errorLanguage => "en_US"},
        :receiverList => {
          :receiver => [{
            :amount => amount,
            :email => payment.source.receiver_email }]}
        })

      refund_response = provider.refund(refund_transaction)

      if refund_response.success?
        payment.source.update_attributes({
          :refunded_at => Time.now,
          :refund_transaction_id => refund_response.refundInfoList.refundInfo.first.encryptedRefundTransactionId,
          :state => "refunded",
          :refund_type => refund_type
        })

        payment.class.create!(
          :order => payment.order,
          :source => payment,
          :payment_method => payment.payment_method,
          :amount => amount.to_f.abs * -1,
          :response_code => refund_response.refundInfoList.refundInfo.first.encryptedRefundTransactionId,
          :state => 'completed'
        )
      end
      refund_response
    end
  end
end

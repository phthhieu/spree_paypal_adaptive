module Spree
  Payment.class_eval do

    durably_decorate :invalidate_old_payments, mode: 'soft', sha: 'c75f9f627cf0d91b32bd1a8851108c4c5624f580' do
      if state != 'invalid' and state != 'failed'
        order.payments.with_state('checkout').where("id != ?", self.id).each do |payment|
          payment.invalidate! unless payment.payment_method.type == "Spree::Gateway::PayPalAdaptive"
        end
      end
    end

  end
end


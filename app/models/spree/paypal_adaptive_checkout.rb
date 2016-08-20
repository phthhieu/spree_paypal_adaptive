module Spree
  class PaypalAdaptiveCheckout < ActiveRecord::Base
    enum paid_state: %w( paid_primary paid_secondary ).freeze
  end
end

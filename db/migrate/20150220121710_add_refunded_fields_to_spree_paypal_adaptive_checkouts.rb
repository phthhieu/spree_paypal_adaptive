class AddRefundedFieldsToSpreePaypalAdaptiveCheckouts < ActiveRecord::Migration
  def change
    add_column :spree_paypal_adaptive_checkouts, :refund_correlation_id, :string
    add_column :spree_paypal_adaptive_checkouts, :refunded_at, :datetime
    add_column :spree_paypal_adaptive_checkouts, :refund_type, :string
  end
end

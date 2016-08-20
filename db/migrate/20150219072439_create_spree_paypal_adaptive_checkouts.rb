class CreateSpreePaypalAdaptiveCheckouts < ActiveRecord::Migration
  def change
    create_table :spree_paypal_adaptive_checkouts do |t|
      t.string    :pay_key
      t.string    :state,                default: "complete"
      t.string    :receiver_email
      t.string    :transaction_id
      t.string    :refund_transaction_id
      t.datetime  :refunded_at
      t.string    :refund_type
      t.integer   :paid_state,           default: 0
      t.timestamps
    end
  end
end

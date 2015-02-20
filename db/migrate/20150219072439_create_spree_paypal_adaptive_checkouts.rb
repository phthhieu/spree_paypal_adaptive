class CreateSpreePaypalAdaptiveCheckouts < ActiveRecord::Migration
  def change
    create_table :spree_paypal_adaptive_checkouts do |t|
      t.string :pay_key
      t.timestamps
    end
  end
end

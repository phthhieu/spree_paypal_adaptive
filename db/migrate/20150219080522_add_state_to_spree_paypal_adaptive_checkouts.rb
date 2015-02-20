class AddStateToSpreePaypalAdaptiveCheckouts < ActiveRecord::Migration
  def change
    add_column :spree_paypal_adaptive_checkouts, :state, :string, :default => "complete"
  end
end

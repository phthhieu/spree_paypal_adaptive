class AddPaypalEmailToSpreeSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :paypal_email, :string
  end
end

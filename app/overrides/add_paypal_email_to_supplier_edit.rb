Deface::Override.new(:virtual_path => 'spree/admin/suppliers/_form',
  :name => 'add_paypal_email_to_supplier_edit',
  :insert_before => "erb[silent]:contains('if spree_current_user.admin?')",
  :text => "
    <%= form.field_container :paypal_email do %>
      <%= form.label :paypal_email, Spree::Supplier.human_attribute_name(:paypal_email) %>:<br />
      <%= form.text_field :paypal_email, :class => 'fullwidth text' %>
    <% end %>
  ")
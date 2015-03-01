Deface::Override.new(:virtual_path => 'spree/admin/payments/_list',
  :name => 'add_receiver_email_to_payments_list_header',
  :insert_before => "th:contains('Spree.t(:payment_state)')",
  :text => "
    <th><%= Spree.t(:reseiver_email, :scope => 'paypal_adaptive') %></th>
  ")
  
Deface::Override.new(:virtual_path => 'spree/admin/payments/_list',
  :name => 'add_receiver_email_to_payments_list_row',
  :insert_before => "td:contains('payment.state')",
  :text => "
    <td class='align-center'><%= payment.source.receiver_email if defined?(payment.source.receiver_email) %></td>
  ")
  

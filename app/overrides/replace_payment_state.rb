Deface::Override.new(:virtual_path => 'spree/admin/payments/_list',
  :name => 'replace_payment_state_in_list',
  :replace => "td:contains('payment.state')",
  :text => "
    <% if defined?(payment.source.state) %>
      <td class='align-center'> <span class='state <%= payment.source.state %>'><%= Spree.t(payment.source.state, :scope => 'paypal_adaptive.payment_state') %></span></td>
    <% else %>
      <td class='align-center'> <span class='state <%= payment.state %>'><%= Spree.t(payment.state, :scope => :payment_states, :default => payment.state.capitalize) %></span></td>
    <% end %>
  ")
  

Deface::Override.new(:virtual_path => 'spree/admin/payments/show',
  :name => 'replace_payment_state_in_show',
  :replace => "span:contains('Spree.t(@payment.state, :scope => :payment_states, :default => @payment.state.capitalize)')",
  :text => "
    <% if defined?(@payment.source.state) %>
      <span class='state <%= @payment.source.state %>'>
        <%= Spree.t(@payment.source.state, :scope => 'paypal_adaptive.payment_state') %>
      </span>
    <% else %>
      <span class='state <%= @payment.state %>'>
        <%= Spree.t(@payment.state, :scope => :payment_states, :default => @payment.state.capitalize) %>
      </span>
    <% end %>
  ")
//= require spree/backend

SpreePaypalAdaptive = {
  hideSettings: function(paymentMethod) {
    if (SpreePaypalAdaptive.paymentMethodID && paymentMethod.val() == SpreePaypalAdaptive.paymentMethodID) {
      $('.payment-method-settings').children().hide();
      $('#payment_amount').prop('disabled', 'disabled');
      $('button[type="submit"]').prop('disabled', 'disabled');
      $('#paypal-adaptive-warning').show();
    } else if (SpreePaypalAdaptive.paymentMethodID) {
      $('.payment-method-settings').children().show();
      $('button[type=submit]').prop('disabled', '');
      $('#payment_amount').prop('disabled', '')
      $('#paypal-adaptive-warning').hide();
    }
  }
}

$(document).ready(function() {
  checkedPaymentMethod = $('[data-hook="payment_method_field"] input[type="radio"]:checked');
  SpreePaypalAdaptive.hideSettings(checkedPaymentMethod);
  paymentMethods = $('[data-hook="payment_method_field"] input[type="radio"]').click(function (e) {
    SpreePaypalAdaptive.hideSettings($(e.target));
  });
})
//= require spree/backend

SpreePaypalAdaptive = {
  hideSettings: function(paymentMethod) {
// if used simultaneously with Better Spree Paypal
	if (typeof SpreePaypalExpress !== 'undefined') {
		ppExpress = (SpreePaypalExpress.paymentMethodID && (paymentMethod.val() == SpreePaypalExpress.paymentMethodID))
	} else {
		ppExpress = false
	}
    if ((SpreePaypalAdaptive.paymentMethodID && (paymentMethod.val() == SpreePaypalAdaptive.paymentMethodID)) || ppExpress) {
      $('.payment-method-settings').children().hide();
      $('#payment_amount').prop('disabled', 'disabled');
      $('button[type="submit"]').prop('disabled', 'disabled');
      $('#paypal-adaptive-warning, #payment_method_'+SpreePaypalAdaptive.paymentMethodID).show();
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
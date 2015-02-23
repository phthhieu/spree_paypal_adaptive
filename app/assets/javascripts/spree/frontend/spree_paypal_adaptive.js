//= require spree/frontend

SpreePaypalAdaptive = {
  updateSaveAndContinueVisibility: function() {
// if used simultaneously with Better Spree Paypal
    if (this.isButtonHidden()) {
      $(this).trigger('hideSaveAndContinue')
    } else {
      $(this).trigger('showSaveAndContinue')
    }
  },
  isButtonHidden: function () {
    paymentMethod = this.checkedPaymentMethod();
	if (typeof SpreePaypalExpress !== 'undefined') {
		ppExpress = (SpreePaypalExpress.paymentMethodID && (paymentMethod.val() == SpreePaypalExpress.paymentMethodID))
	} else {
		ppExpress = false
	}
    return (!$('#use_existing_card_yes:checked').length && 
    	((SpreePaypalAdaptive.paymentMethodID && (paymentMethod.val() == SpreePaypalAdaptive.paymentMethodID)) || ppExpress));
  },
  checkedPaymentMethod: function() {
    return $('div[data-hook="checkout_payment_step"] input[type="radio"][name="order[payments_attributes][][payment_method_id]"]:checked');
  },
  hideSaveAndContinue: function() {
    $("#checkout_form_payment [data-hook=buttons]").hide();
  },
  showSaveAndContinue: function() {
    $("#checkout_form_payment [data-hook=buttons]").show();
  }
}

$(document).ready(function() {
  SpreePaypalAdaptive.updateSaveAndContinueVisibility();
  paymentMethods = $('div[data-hook="checkout_payment_step"] input[type="radio"]').click(function (e) {
    SpreePaypalAdaptive.updateSaveAndContinueVisibility();
  });
})

SpreePaypalAdaptive
===================

This is extension for [Spree MarketPlace](https://github.com/JDutil/spree_marketplace)

It is uses [Adaptive Payments SDK](https://github.com/paypal/adaptivepayments-sdk-ruby)

This extension is a remade of [Better Spree PayPal Express](https://github.com/spree-contrib/better_spree_paypal_express) extension

Installation
------------

Add spree_paypal_adaptive to your Gemfile:

```ruby
gem 'spree_paypal_adaptive', github: 'lemboy/spree_paypal_adaptive'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_paypal_adaptive:install
```

Restart server.

Setup
-------

In Spree create a new payment method with "Spree::Gateway::PayPalAdaptive" as the provider. Fill appropriate fields for this pay method.

Fill Paypal Email fields for suppliers.

Refund note
-------

Receiver must set grant permission for pay refund: 
- in receiver PayPal account goto Profile -> My selling tools -> API access -> Grant API permission
- in textbox "Third Party Permission Username" enter API Credentials Username (for example test-facilitator_api1.example.com) and click Lookup button
- enable checkbox for "Issue a refund for a specific transaction" and click Add button

[Thanx to](http://stackoverflow.com/a/12542978/4593411).


Testing
-------

Not yet implemented.

ToDo
-------

* End up Refund capabilities
* Order Adjustments
* Chained pays
* Items detail in PayPal
* Check PayPal Email presence
* Check count of receivers in Order (up to 6)
* Check zero amount
* Fix JS code (?) if used simultaneously with Better Spree Paypal

# PayPal Recurring Billing

Nando Vieira's PayPal Express Checkout API Client for recurring billing, with some improvements.

[![Build Status](http://img.shields.io/travis/t-bullock/paypal-recurring.svg?style=flat-square)](https://travis-ci.org/t-bullock/paypal-recurring)

## Installation

  ```
  $ gem install paypal-recurring
  ```

If you're using bundler, add this to your gemfile instead.

  ```ruby
  gem 'paypal-recurring', :github => 't-bullock/paypal-recurring'
  ```

## Usage

First you need to set up your credentials. Create a file `config/initializers/paypal.rb` and add the following with your own credentials from PayPal.

  ```ruby
  PayPal::Recurring.configure do |config|
    config.sandbox = true
    config.username = "seller_1308793919_biz_api1.simplesideias.com.br"
    config.password = "1308793931"
    config.signature = "AFcWxV21C7fd0v3bYYYRCpSSRl31AzaB6TzXx5amObyEghjU13.0av2Y"
  end
  ```

Now you can request a new payment authorization.

  ```ruby
  ppr = PayPal::Recurring.new({
    :return_url   => "http://example.com/paypal/thank_you",
    :cancel_url   => "http://example.com/paypal/canceled",
    :ipn_url      => "http://example.com/paypal/ipn",
    :description  => "Awesome - Monthly Subscription",
    :amount       => "9.00",
    :currency     => "USD",
    :bg_color     => "#EFC687", # custom background color (optional)
    :border_color => "#3F3F3F", # custom border color (optional)
    :brand_name   => "My Store title!", # custom store title (optional)
    :logo         => "http://#{your_host}/images/logo.png") # custom logo (optional, overrides brand name)
  })

  response = ppr.checkout
  puts response.checkout_url if response.valid?
  ```

You need to redirect your user to the url returned by `response.checkout_url`.
After the user accepts or rejects your payment request, he/she will be redirected to one of those urls you specified.
The return url will receive two parameters: `PAYERID` and `TOKEN`. You can use the `TOKEN` parameter to identify your user in your database.

If you need to retrieve information about your buyer (like address or e-mail), you can use the `checkout_details()` method.

  ```ruby
  ppr = PayPal::Recurring.new(:token => "EC-05C46042TU8306821")
  response = ppr.checkout_details
  ```

Now you need to request payment. The information you provide here should be exactly the same as when you started the checkout process.

  ```ruby
  ppr = PayPal::Recurring.new({
    :token       => "EC-05C46042TU8306821",
    :payer_id    => "WTTS5KC2T46YU",
    :amount      => "9.00",
    :description => "Awesome - Monthly Subscription"
  })

  response = ppr.request_payment
  response.approved?
  response.completed?
  ```

Finally, you need to create a new recurring profile.

  ```ruby
  ppr = PayPal::Recurring.new({
    :amount          => "9.00",
    :currency        => "USD",
    :description     => "Awesome - Monthly Subscription",
    :ipn_url         => "http://example.com/paypal/ipn",
    :frequency       => 1,
    :token           => "EC-05C46042TU8306821",
    :period          => :monthly,
    :reference       => "1234",
    :payer_id        => "WTTS5KC2T46YU",
    :start_at        => Time.now,
    :failed          => 1,
    :outstanding     => :next_billing,
    :billing_cycles  => 0 # Number of billing cycles you want this subscription to run for. '0' runs forever
  })

  response = ppr.create_recurring_profile
  puts response.profile_id
  ```

Optionally you can also specify a trial period, frequency, and length.

  ```ruby
  ppr = PayPal::Recurring.new({
    :amount          => "9.00",
    :currency        => "USD",
    :description     => "Awesome - Monthly Subscription",
    :ipn_url         => "http://example.com/paypal/ipn",
    :frequency       => 1,
    :token           => "EC-05C46042TU8306821",
    :period          => :monthly,
    :reference       => "1234",
    :payer_id        => "WTTS5KC2T46YU",
    :start_at        => Time.now,
    :failed          => 1,
    :outstanding     => :next_billing,
    :billing_cycles  => 0,
    :trial_length    => 1,
    :trial_period    => :monthly,
    :trial_frequency => 1
  })
  ```

You can manage your recurring profile.

  ```ruby
  ppr = PayPal::Recurring.new(:profile_id => "I-VCEL6TRG35CU")

  ppr.suspend
  ppr.reactivate
  ppr.cancel
  ```

### What information do I need to keep?

You should save two paramaters to your database: `TOKEN` and `PROFILEID`.

`TOKEN` is required when user returns to your website after he/she authorizes (or cancels) the billing process. You need to save it so you can find the user later. You can remove this info after the payment and recurring profile are set.

The `PROFILEID` allows you to manage the recurring profile, like canceling billing when a user doesn't
want to use your service anymore.

**NOTE:** `TOKEN` will expire after approximately 3 hours.

## Maintainer

* Nando Vieira (http://nandovieira.com.br)

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

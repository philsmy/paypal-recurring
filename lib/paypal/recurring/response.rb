module PayPal
  module Recurring
    module Response
      autoload :Base, "paypal/recurring/response/base"
      autoload :Checkout, "paypal/recurring/response/checkout"
      autoload :Details, "paypal/recurring/response/details"
      autoload :Payment, "paypal/recurring/response/payment"
      autoload :ManageProfile, "paypal/recurring/response/manage_profile"
      autoload :Profile, "paypal/recurring/response/profile"
      autoload :Refund,  "paypal/recurring/response/refund"
      autoload :Transaction, "paypal/recurring/response/transaction"
      autoload :TransactionSearch, "paypal/recurring/response/transaction_search"

      RESPONDERS = {
        :checkout           => "Checkout",
        :details            => "Details",
        :payment            => "Payment",
        :profile            => "Profile",
        :create_profile     => "ManageProfile",
        :manage_profile     => "ManageProfile",
        :update_profile     => "ManageProfile",
        :refund             => "Refund",
        :transaction        => "Transaction",
        :transaction_search => "TransactionSearch"
      }

      def self.process(method, response)
        response_class = PayPal::Recurring::Response.const_get(RESPONDERS[method])
        response_class.new(response)
      end
    end
  end
end

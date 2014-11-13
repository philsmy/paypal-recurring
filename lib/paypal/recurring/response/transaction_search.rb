module PayPal
  module Recurring
    module Response
      class TransactionSearch < Base
        TransactionResult = Struct.new(:id, :type, :status, :amount, :currency, :created_at) do
          def details
            PayPal::Recurring.new(
              transaction_id: self.id
            ).transaction_details
          end
        end

        attr_reader :transactions

        def initialize(response=nil)
          super

          map_transactions
        end

        private

        def map_transactions
          ids = params.keys
            .map { |k| /^L_TRANSACTIONID(?<id>\d+)/.match(k) }
            .compact
            .map { |match| match[:id] }

          @transactions = ids.map do |id|
            TransactionResult.new(
              params[:"L_TRANSACTIONID#{id}"],
              params[:"L_TYPE#{id}"],
              params[:"L_STATUS#{id}"],
              params[:"L_AMT#{id}"],
              params[:"L_CURRENCYCODE#{id}"],
              DateTime.parse(params[:"L_TIMESTAMP#{id}"])
            )
          end
        end
      end
    end
  end
end
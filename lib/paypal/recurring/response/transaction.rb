module PayPal
  module Recurring
    module Response
      class Transaction < Base
        mapping(
          :amount           => :AMT,
          :country_code     => :COUNTRYCODE,
          :currency         => :CURRENCYCODE,
          :description      => :SUBJECT,
          :email            => :EMAIL,
          :extra_amount     => :L_AMT1,
          :extra_name       => :L_NAME1,
          :first_name       => :FIRSTNAME,
          :item_amount      => :L_AMT0,
          :item_name        => :L_NAME0,
          :last_name        => :LASTNAME,
          :order_time       => :ORDERTIME,
          :payer_id         => :PAYERID,
          :payer_status     => :PAYERSTATUS,
          :payment_type     => :PAYMENTTYPE,
          :pending_reason   => :PENDINGREASON,
          :receiver_email   => :RECEIVEREMAIL,
          :receiver_id      => :RECEIVERID,
          :status           => :PAYMENTSTATUS,
          :tax_amount       => :TAXAMT,
          :timestamp        => :TIMESTAMP,
          :transaction_id   => :TRANSACTIONID,
          :transaction_type => :TRANSACTIONTYPE
        )

        def completed?
          params[:PAYMENTSTATUS] == "Completed"
        end

        def approved?
          params[:ACK] == "Success"
        end
      end
    end
  end
end
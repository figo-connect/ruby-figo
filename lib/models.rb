#
# Copyright (c) 2013 figo GmbH
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 

require "date"
require "flt"


module Figo

  # Set decimal precision to two digits.
  Flt::DecNum.context.precision = 2

  class AccountType
    GIRO        = "Giro account"
    SAVINGS     = "Savings account"
    CREDIT_CARD = "Credit card"
    LOAN        = "Loan account"
    PAYPAL      = "PayPal"
    UNKNOWN     = "Unknown"
  end

  class TransactionType
    TRANSFER            = "Transfer"
    STANDING_ORDER      = "Standing order"
    DIRECT_DEBIT        = "Direct debit"
    SALARY_OR_RENT      = "Salary or rent"
    ELECTRONIC_CASH     = "Electronic cash"
    GELDKARTE           = "GeldKarte"
    ATM                 = "ATM"
    CHARGES_OR_INTEREST = "Charges or interest"
    UNKNOWN             = "Unknown"
  end

  class Base # :nodoc:

    def initialize(session, hash)
      @session = session

      hash.each do |key, value|
        if key == "status"
          value = SynchronizationStatus.new(session, value)
        elsif key == "amount" or key == "balance"
          value = Flt::DecNum(value.to_s)
        elsif key.end_with?("_date")
          value = DateTime.iso8601(value)
        elsif key.end_with?("_timestamp")
          value = Date.iso8601(value)
        end
        instance_variable_set("@#{key}", value)
      end
    end

  end

  class Account < Base

    attr_accessor :account_id
    attr_accessor :bank_id
    attr_accessor :name
    attr_accessor :owner
    attr_accessor :auto_sync
    attr_accessor :account_number
    attr_accessor :bank_code
    attr_accessor :bank_name
    attr_accessor :currency
    attr_accessor :iban
    attr_accessor :bic
    attr_accessor :type
    attr_accessor :icon
    attr_accessor :in_total_balance
    attr_accessor :preview
    attr_accessor :status

    # Request balance.
    def balance
      response = @session.query_api("/rest/accounts/#{@account_id}/balance")
      return AccountBalance.new(@session, response)
    end

    # Request list of transactions.
    def transactions(since = nil, start_id = nil, count = 1000, include_pending = false)
      data = {}
      data["since"] = (since.is_a?(Date) ? since.to_s : since) unless since.nil?
      data["start_id"] = start_id unless start_id.nil?
      data["count"] = count.to_s
      data["include_pending"] = include_pending ? "1" : "0"
      response = @session.query_api("/rest/accounts/#{@account_id}/transactions?" + URI.encode_www_form(data)) 
      return response["transactions"].map {|transaction| Transaction.new(@session, transaction)}
    end

    # Request a specific transaction.
    def transaction(transaction_id)
      response = @session.query_api("/rest/accounts/#{@account_id}/transactions/#{transaction_id}")
      return Transaction.new(@session, response)
    end

  end

  class AccountBalance < Base

    attr_accessor :balance
    attr_accessor :balance_date
    attr_accessor :credit_line
    attr_accessor :monthly_spending_limit
    attr_accessor :status

  end

  class Transaction < Base

    attr_accessor :transaction_id
    attr_accessor :account_id
    attr_accessor :name
    attr_accessor :account_number
    attr_accessor :bank_code
    attr_accessor :bank_name
    attr_accessor :amount
    attr_accessor :currency
    attr_accessor :booking_date
    attr_accessor :value_date
    attr_accessor :purpose
    attr_accessor :type
    attr_accessor :booking_text
    attr_accessor :booked
    attr_accessor :creation_timestamp
    attr_accessor :modification_timestamp
    attr_accessor :visited

  end

  class SynchronizationStatus < Base

    attr_accessor :code
    attr_accessor :message
    attr_accessor :sync_timestamp
    attr_accessor :success_timestamp

  end

  class Notification < Base

    attr_accessor :notification_id
    attr_accessor :observe_key
    attr_accessor :notify_uri
    attr_accessor :state

  end

end

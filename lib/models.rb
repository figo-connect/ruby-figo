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

  # Account type enumeration.
  class AccountType
    GIRO        = "Giro account"
    SAVINGS     = "Savings account"
    CREDIT_CARD = "Credit card"
    LOAN        = "Loan account"
    PAYPAL      = "PayPal"
    UNKNOWN     = "Unknown"
  end

  # Transaction type enumeration.
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

  # Abstract base class for model objects.
  class Base

    # Instantiate model object from hash.
    #
    # @param session [Session] figo `Session` object
    # @param hash [Hash] use keys of this hash for model object creation
    def initialize(session, hash)
      @session = session

      hash.each do |key, value|
        if key == "status"
          value = SynchronizationStatus.new(session, value)
        elsif key == "amount" or key == "balance" or key == "credit_line" or key == "monthly_spending_limit"
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

  # Object representing one bank account of the user.
  class Account < Base

    # Internal figo Connect account ID.
    # @return [String]
    attr_accessor :account_id

    # Internal figo Connect bank ID.
    # @return [String]
    attr_accessor :bank_id

    # Account name.
    # @return [String]
    attr_accessor :name

    # Account owner.
    # @return [String]
    attr_accessor :owner

    # This flag indicates whether the account will be automatically synchronized.
    # @return [Boolean]
    attr_accessor :auto_sync

    # Account number.
    # @return [String]
    attr_accessor :account_number

    # Bank code.
    # @return [String]
    attr_accessor :bank_code

    # Bank name.
    # @return [String]
    attr_accessor :bank_name

    # Three-character currency code.
    # @return [String]
    attr_accessor :currency

    # IBAN.
    # @return [String]
    attr_accessor :iban

    # BIC.
    # @return [String]
    attr_accessor :bic

    # Account type. One of the constants of the `AccountType` object.
    # @return [String]
    attr_accessor :type

    # Account icon URL.
    # @return [String]
    attr_accessor :icon

    # This flag indicates whether the balance of this account is added to the total balance of accounts.
    # @return [Boolean]
    attr_accessor :in_total_balance

    # This flag indicates whether this account is only shown as preview for an unpaid premium plan.
    # @return [Boolean]
    attr_accessor :preview

    # Synchronization status object.
    # @return [SynchronizationStatus]
    attr_accessor :status

    # Request balance of this account.
    #
    # @return [AccountBalance] account balance object
    def balance
      response = @session.query_api("/rest/accounts/#{@account_id}/balance")
      return AccountBalance.new(@session, response)
    end

    # Request list of transactions of this account.
    #
    # @param since [String, Date] this parameter can either be a transaction ID or a date
    # @param start_id [String] do only return transactions which were booked after the start transaction ID
    # @param count [Integer] limit the number of returned transactions
    # @param include_pending [Boolean] this flag indicates whether pending transactions should be included 
    #        in the response; pending transactions are always included as a complete set, regardless of 
    #        the `since` parameter
    # @return [Array] an array of `Transaction` objects, one for each transaction of this account
    def transactions(since = nil, start_id = nil, count = 1000, include_pending = false)
      data = {}
      data["since"] = (since.is_a?(Date) ? since.to_s : since) unless since.nil?
      data["start_id"] = start_id unless start_id.nil?
      data["count"] = count.to_s
      data["include_pending"] = include_pending ? "1" : "0"
      response = @session.query_api("/rest/accounts/#{@account_id}/transactions?" + URI.encode_www_form(data)) 
      return response["transactions"].map {|transaction| Transaction.new(@session, transaction)}
    end

    # Request specific transaction.
    #
    # @param transaction_id [String] ID of the transaction to be retrieved
    # @return [Transaction] transaction object
    def transaction(transaction_id)
      response = @session.query_api("/rest/accounts/#{@account_id}/transactions/#{transaction_id}")
      return response.nil? ? nil : Transaction.new(@session, response)
    end

  end

  # Object representing the balance of a certain bank account of the user.
  class AccountBalance < Base

    # Account balance or `nil` if the balance is not yet known.
    # @return [DecNum]
    attr_accessor :balance

    # Bank server timestamp of balance or `nil` if the balance is not yet known.
    # @return [Date]
    attr_accessor :balance_date

    # Credit line.
    # @return [DecNum]
    attr_accessor :credit_line

    # User-defined spending limit.
    # @return [DecNum]
    attr_accessor :monthly_spending_limit

    # Synchronization status object.
    # @return [SynchronizationStatus]
    attr_accessor :status

  end

  # Object representing one bank transaction on a certain bank account of the user.
  class Transaction < Base

    # Internal figo Connect transaction ID.
    # @return [String]
    attr_accessor :transaction_id

    # Internal figo Connect account ID.
    # @return [String]
    attr_accessor :account_id

    # Name of originator or recipient.
    # @return [String]
    attr_accessor :name

    # Account number of originator or recipient.
    # @return [String]
    attr_accessor :account_number

    # Bank code of originator or recipien.
    # @return [String]
    attr_accessor :bank_code

    # Bank name of originator or recipient.
    # @return [String]
    attr_accessor :bank_name

    # Transaction amount.
    # @return [DecNum]
    attr_accessor :amount

    # Three-character currency code.
    # @return [String]
    attr_accessor :currency

    # Booking date.
    # @return [Date]
    attr_accessor :booking_date

    # Value date.
    # @return [Date]
    attr_accessor :value_date

    # Purpose text.
    # @return [String]
    attr_accessor :purpose

    # Transaction type. One of the constants of the `TransactionType` object.
    # @return [String]
    attr_accessor :type

    # Booking text.
    # @return [String]
    attr_accessor :booking_text

    # This flag indicates whether the transaction is booked or pending.
    # @return [Boolean]
    attr_accessor :booked

    # Internal creation timestamp on the figo Connect server.
    # @return [DateTime]
    attr_accessor :creation_timestamp

    # Internal modification timestamp on the figo Connect server.
    # @return [DateTime]
    attr_accessor :modification_timestamp

    # This flag indicates whether the transaction has already been marked as visited by the user.
    # @return [Boolean]
    attr_accessor :visited

  end

  # Object representing the bank server synchronization status.
  class SynchronizationStatus < Base

    # Internal figo Connect status code.
    # @return [Integer]
    attr_accessor :code

    # Human-readable error message.
    # @return [String]
    attr_accessor :message

    # Timestamp of last synchronization.
    # @return [DateTime]
    attr_accessor :sync_timestamp

    # Timestamp of last successful synchronization.
    # @return [DateTime]
    attr_accessor :success_timestamp

  end

  # Object representing a configured notification, e.g. a webhook or email hook.
  class Notification < Base

    # Internal figo Connect notification ID from the notification registration response.
    # @return [String]
    attr_accessor :notification_id

    # One of the notification keys specified in the figo Connect API specification.
    # @return [String]
    attr_accessor :observe_key

    # Notification messages will be sent to this URL.
    # @return [String]
    attr_accessor :notify_uri

    # State similiar to sync and logon process. It will passed as POST payload for webhooks.
    # @return [String]
    attr_accessor :state

  end

end

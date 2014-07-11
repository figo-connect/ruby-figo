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

  # Abstract base class for model objects.
  class Base
    # Attributes to be dumped (called by modify and create)
    @dump_attributes = []
    def self.dump_attributes
      @dump_attributes
    end

    # Instantiate model object from hash.
    #
    # @param session [Session] figo `Session` object
    # @param hash [Hash] use keys of this hash for model object creation
    def initialize(session, hash)
      @session = session

      hash.each do |key, value|
        key = key.to_s if key.is_a? Symbol
        next unless respond_to? "#{key}="
        next if value.nil?

        if key == "status" and value.is_a? Hash
          value = SynchronizationStatus.new(session, value)
        elsif key == "balance" and value.is_a? Hash
          value = AccountBalance.new(session, value)
        elsif key == "amount" or key == "balance" or key == "credit_line" or key == "monthly_spending_limit"
          value = Flt::DecNum(value.to_s)
        elsif key.end_with?("_date")
          value = DateTime.iso8601(value)
        elsif key.end_with?("_timestamp")
          value = DateTime.iso8601(value)
        end
        send("#{key}=", value)
      end
    end

    # Dump committable attributes to a hash
    def dump
      result = {}
      self.class.dump_attributes.each do |attribute|
        value = send attribute
        next if value.nil?
        value = value.to_f if value.is_a? Flt::DecNum

        result[attribute] = value
      end
      return result
    end
  end

  # Object representing an User
  class User < Base
    @dump_attributes = [:name, :address, :send_newsletter, :language]

    # Internal figo Connect User ID
    # @return [String]
    attr_accessor :User_id

    # First and last name
    # @return [String]
    attr_accessor :name

    # Email address
    # @return [String]
    attr_accessor :email

    #Postal address for bills, etc.
    # @return [Dict]
    attr_accessor :address

    # This flag indicates whether the email address has been verified
    # @return [Boolean]
    attr_accessor :verified_email

    # This flag indicates whether the User has agreed to be contacted by email
    # @return [Boolean]
    attr_accessor :send_newsletter

    # Two-letter code of preferred language
    # @return [String]
    attr_accessor :language

    # This flag indicates whether the figo Account plan is free or premium
    # @return [Boolean]
    attr_accessor :premium

    # Timestamp of premium figo Account expiry
    # @return [DateTime]
    attr_accessor :premium_expires_on

    # Provider for premium subscription or Null of no subscription is active
    # @return [String]
    attr_accessor :premium_subscription

    # Timestamp of figo Account registration
    # @return [DateTime]
    attr_accessor :join_date
  end

  # Object representing one bank account of the User
  class Account < Base
    @dump_attributes = [:name, :owner, :auto_sync]

    # Internal figo Connect account ID
    # @return [String]
    attr_accessor :account_id

    # Internal figo Connect bank ID
    # @return [String]
    attr_accessor :bank_id

    # Account name
    # @return [String]
    attr_accessor :name

    # Account owner
    # @return [String]
    attr_accessor :owner

    # This flag indicates whether the account will be automatically synchronized
    # @return [Boolean]
    attr_accessor :auto_sync

    # Account number
    # @return [String]
    attr_accessor :account_number

    # Bank code
    # @return [String]
    attr_accessor :bank_code

    # Bank name
    # @return [String]
    attr_accessor :bank_name

    # Three-character currency code
    # @return [String]
    attr_accessor :currency

    # IBAN
    # @return [String]
    attr_accessor :iban

    # BIC
    # @return [String]
    attr_accessor :bic

    # Account type
    # @return [String]
    attr_accessor :type

    # Account icon URL
    # @return [String]
    attr_accessor :icon

    # Account icon URLs for other resolutions
    # @return [Hash]
    attr_accessor :additional_icons

    # This flag indicates whether the balance of this account is added to the total balance of accounts
    # @return [Boolean]
    attr_accessor :in_total_balance

    # Synchronization status object
    # @return [SynchronizationStatus]
    attr_accessor :status

    # AccountBalance object
    # @return [AccountBalance]
    attr_accessor :balance

    # Request list of transactions of this account
    #
    # @param since [String, Date] this parameter can either be a transaction ID or a date
    # @param count [Integer] limit the number of returned transactions
    # @param offset [Integer] which offset into the result set should be used to determin the first transaction to return (useful in combination with count)
    # @param include_pending [Boolean] this flag indicates whether pending transactions should be included
    #        in the response; pending transactions are always included as a complete set, regardless of
    #        the `since` parameter
    # @return [Array] an array of `Transaction` objects, one for each transaction of this account
    def transactions(since = nil, count = 1000, offset = 0, include_pending = false)
      @session.transactions @account_id, since, count, offset, include_pending
    end

    # Request specific transaction.
    #
    # @param transaction_id [String] ID of the transaction to be retrieved
    # @return [Transaction] transaction object
    def get_transaction(transaction_id)
      @session.get_transaction @acount_id, transaction_id
    end

    # Retrieve list of payments on this account
    #
    # @return [Payment] an array of `Payment` objects, one for each payment
    def payments
      @session.payments @account_id
    end

    # Retrieve specific payment on this account
    #
    # @param payment_id [String] ID of the notification to be retrieved
    # @return [Payment] `Payment` object for the respective payment
    def get_payment(payment_id)
      @session.get_payment @account_id, payment_id
    end

    # Retrieve bank of this account
    #
    # @return [Bank] `Bank` object for the respective bank
    def bank
      @session.get_bank @bank_id
    end
  end

  # Object representing the balance of a certain bank account of the User
  class AccountBalance < Base
    @dump_attributes = [:credit_line, :monthly_spending_limit]

    # Account balance or `nil` if the balance is not yet known
    # @return [DecNum]
    attr_accessor :balance

    # Bank server timestamp of balance or `nil` if the balance is not yet known
    # @return [Date]
    attr_accessor :balance_date

    # Credit line.
    # @return [DecNum]
    attr_accessor :credit_line

    # User-defined spending limit
    # @return [DecNum]
    attr_accessor :monthly_spending_limit

    # Synchronization status object
    # @return [SynchronizationStatus]
    attr_accessor :status
  end

  # Object representing a bank, i.e. an connection to a bank
  class Bank < Base
    @dump_attributes = [:sepa_creditor_id]

    # SEPA direct debit creditor ID
    # @return [String]
    attr_accessor :sepa_creditor_id

    # This flag indicates whether the user has chosen to save the PIN on the figo Connect server
    # @return [Boolean]
    attr_accessor :save_pin
  end

  # Object representing one bank transaction on a certain bank account of the User
  class Transaction < Base
    @dump_attributes = []

    # Internal figo Connect transaction ID
    # @return [String]
    attr_accessor :transaction_id

    # Internal figo Connect account ID
    # @return [String]
    attr_accessor :account_id

    # Name of originator or recipient
    # @return [String]
    attr_accessor :name

    # Account number of originator or recipient
    # @return [String]
    attr_accessor :account_number

    # Bank code of originator or recipient
    # @return [String]
    attr_accessor :bank_code

    # Bank name of originator or recipient
    # @return [String]
    attr_accessor :bank_name

    # Transaction amount
    # @return [DecNum]
    attr_accessor :amount

    # Three-character currency code
    # @return [String]
    attr_accessor :currency

    # Booking date
    # @return [Date]
    attr_accessor :booking_date

    # Value date
    # @return [Date]
    attr_accessor :value_date

    # Purpose text
    # @return [String]
    attr_accessor :purpose

    # Transaction type
    # @return [String]
    attr_accessor :type

    # Booking text
    # @return [String]
    attr_accessor :booking_text

    # This flag indicates whether the transaction is booked or pending
    # @return [Boolean]
    attr_accessor :booked

    # Internal creation timestamp on the figo Connect server
    # @return [DateTime]
    attr_accessor :creation_timestamp

    # Internal modification timestamp on the figo Connect server
    # @return [DateTime]
    attr_accessor :modification_timestamp
  end

  # Object representing the bank server synchronization status
  class SynchronizationStatus < Base
    @dump_attributes = []

    # Internal figo Connect status code
    # @return [Integer]
    attr_accessor :code

    # Human-readable error message
    # @return [String]
    attr_accessor :message

    # Timestamp of last synchronization
    # @return [DateTime]
    attr_accessor :sync_timestamp

    # Timestamp of last successful synchronization
    # @return [DateTime]
    attr_accessor :success_timestamp
  end

  # Object representing a configured notification, e.g. a webhook or email hook
  class Notification < Base
    @dump_attributes = [:observe_key, :notify_uri, :state]

    # Internal figo Connect notification ID from the notification registration response
    # @return [String]
    attr_accessor :notification_id

    # One of the notification keys specified in the figo Connect API specification
    # @return [String]
    attr_accessor :observe_key

    # Notification messages will be sent to this URL
    # @return [String]
    attr_accessor :notify_uri

    # State similiar to sync and logon process. It will passed as POST payload for webhooks
    # @return [String]
    attr_accessor :state
  end

  # Object representing a Payment
  class Payment < Base
    @dump_attributes = [:type, :name, :account_number, :bank_code, :amount, :currency, :purpose]

    # Internal figo Connect payment ID
    # @return [String]
    attr_accessor :payment_id

    # Internal figo Connect account ID
    # @return [String]
    attr_accessor :account_id

    # Payment type
    # @return [String]
    attr_accessor :type

    # Name of creditor or debtor
    # @return [String]
    attr_accessor :name

    # Account number of creditor or debtor
    # @return [String]
    attr_accessor :account_number

    # Bank code of creditor or debtor
    # @return [String]
    attr_accessor :bank_code

    # Bank name of creditor or debtor
    # @return [String]
    attr_accessor :bank_name

    # Icon of creditor or debtor bank
    # @return [String]
    attr_accessor :bank_icon

    # Icon of the creditor or debtor bank in other resolutions
    # @return [Hash]
    attr_accessor :bank_additional_icons

    # Order amount
    # @return [DecNum]
    attr_accessor :amount

    # Three-character currency code
    # @return [String]
    attr_accessor :currency

    # Purpose text
    # @return [String]
    attr_accessor :purpose

    # Timestamp of submission to the bank server
    # @return [DateTime]
    attr_accessor :submission_timestamp

    # Internal creation timestamp on the figo Connect server
    # @return [DateTime]
    attr_accessor :creation_timestamp

    # Internal modification timestamp on the figo Connect server
    # @return [DateTime]
    attr_accessor :modification_timestamp

    # ID of the transaction corresponding to this payment. This field is only set if the payment has been matched to a transaction
    # @return [String]
    attr_accessor :transaction_id
  end
end

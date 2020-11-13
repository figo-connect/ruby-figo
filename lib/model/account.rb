# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    # Object representing one bank account of the User
    class Account < Base
      DUMP_ATTRIBUTES = %i[name owner auto_sync].freeze

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

      # Supported Tan Schemes
      # @return [Array]
      attr_accessor :supported_tan_schemes

      # Save Pin
      # @return [Boolean]
      attr_accessor :save_pin

      # Supported Payments
      # @return [Hash]
      attr_accessor :supported_payments

      # Internal figo Connect account ID
      # @return [String]
      attr_accessor :access_id

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

      # Is account managed by multiple people
      # @return [Boolean]
      attr_accessor :is_jointly_managed

      # Request list of transactions of this account
      #
      # @param since [String, Date] this parameter can either be a transaction ID or a date
      # @param count [Integer] limit the number of returned transactions
      # @param offset [Integer] which offset into the result set should be used to determin
      #        the first transaction to return (useful in combination with count)
      # @param include_pending [Boolean] this flag indicates whether pending transactions should be included
      #        in the response; pending transactions are always included as a complete set, regardless of
      #        the `since` parameter
      # @return [Array] an array of `Transaction` objects, one for each transaction of this account
      def transactions(since = nil, count = 1000, offset = 0, include_pending = false)
        params = { since: since, count: count, offset: offset, include_pending: include_pending }
        @session.list_transactions_of_account @account_id, params
      end

      # Request specific transaction.
      #
      # @param transaction_id [String] ID of the transaction to be retrieved
      # @return [Transaction] transaction object
      def get_transaction(transaction_id)
        @session.get_transaction @account_id, transaction_id
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
  end
end

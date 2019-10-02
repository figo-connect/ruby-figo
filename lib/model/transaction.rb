# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    # Object representing one bank transaction on a certain bank account of the User
    class Transaction < Base

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

      # IBAN
      # @return [String]
      attr_accessor :iban

      # Transaction Code
      # @return [Integer]
      attr_accessor :transaction_code

      # Categories
      # @return [Array]
      attr_accessor :categories

      # Visited
      # @return [Boolean]
      attr_accessor :visited

      # Prima Nota Number
      # @return [String]
      attr_accessor :prima_nota_number

      # Customer Reference
      # @return [String]
      attr_accessor :customer_reference

      # Sepa Purpose Code
      # @return [String]
      attr_accessor :sepa_purpose_code

      # Sepa Remittance Info
      # @return [String]
      attr_accessor :sepa_remittance_info

      # Booking Key
      # @return [String]
      attr_accessor :booking_key

      # SEPA creditor identifier
      # @return [String]
      attr_accessor :creditor_id

      # End to End Reference
      # @return [String]
      attr_accessor :end_to_end_reference

      # Mandate Reference
      # @return [String]
      attr_accessor :mandate_reference

      # Booked At
      # @return [DateTime]
      attr_accessor :booked_at

      # Settled At
      # @return [DateTime]
      attr_accessor :settled_at

      # Created At
      # @return [DateTime]
      attr_accessor :created_at

      # Modified At
      # @return [DateTime]
      attr_accessor :modified_at

      # BIC
      # @return [String]
      attr_accessor :bic
    end
  end
end

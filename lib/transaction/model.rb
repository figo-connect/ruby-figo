require_relative "../base.rb"
module Figo
  # Object representing one bank transaction on a certain bank account of the User
  class Transaction < Base
    @dump_attributes = []

    def initialize(session, json)
      super(session, json)
    end

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

    # Missing attributes
    attr_accessor :iban
    attr_accessor :bic
    attr_accessor :sepa_remittance_info
    attr_accessor :end_to_end_reference
    attr_accessor :customer_reference
  end
end

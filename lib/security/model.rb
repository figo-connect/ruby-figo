# frozen_string_literal: true

require_relative '../base.rb'
module Figo
  # Object representing a Payment
  class Security < Base
    @dump_attributes = %i[
      name isin wkn currency quantity amount
      amount_original_currency exchange_rate
      price price_currency purchase_price
      purchase_price_currency visited
    ]

    # Name of creditor or debtor
    # @return [String]
    attr_accessor :name

    # Order amount
    # @return [DecNum]
    attr_accessor :amount

    # Three-character currency code
    # @return [String]
    attr_accessor :currency

    # Internal figo Connect security ID
    # @return [String]
    attr_accessor :security_id

    # Internal figo Connect account ID
    # @return [String]
    attr_accessor :account_id

    # International Securities Identification Number
    # @return [String]
    attr_accessor :isin

    # Wertpapierkennnummer (if available)
    # @return [String]
    attr_accessor :wkn

    # Number of pieces or value
    # @return [Number]
    attr_accessor :quantity

    # Monetary value in trading currency
    # @return [Number]
    attr_accessor :amount_original_currency

    # Exchange rate between trading and account currency
    # @return [Number]
    attr_accessor :exchange_rate

    # Current price
    # @return [Number]
    attr_accessor :price

    # Currency of current price
    # @return [String]
    attr_accessor :price_currency

    # Purchase price
    # @return [Number]
    attr_accessor :purchase_price

    # Currency of purchase price
    # @return [String]
    attr_accessor :purchase_price_currency

    # This flag indicates whether the security has already been marked as visited by the user
    # @return [Boolean]
    attr_accessor :visited

    # Trading timestamp
    # @return [Date]
    attr_accessor :trade_timestamp

    # Internal creation timestamp on the figo Connect server
    # @return [Date]
    attr_accessor :creation_timestamp

    # Internal modification timestamp on the figo
    # @return [Date]
    attr_accessor :modification_timestamp
  end
end

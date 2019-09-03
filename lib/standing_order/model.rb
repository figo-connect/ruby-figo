# frozen_string_literal: true

require_relative '../base.rb'
module Figo
  # Object representing a Payment
  class StandingOrder < Base
    @dump_attributes = []

    # Name of creditor or debtor
    # @return [String]
    attr_accessor :name

    # Internal figo Connect standing order ID
    # @return [String]
    attr_accessor :standing_order_id

    # Internal figo Connect account ID
    # @return [String]
    attr_accessor :account_id

    # First execution date of the standing order
    # @return [Date]
    attr_accessor :first_execution_date

    # Last execution date of the standing order (this field might be emtpy, if no last execution date is set)
    # @return [Date]
    attr_accessor :last_execution_date

    # The day the standing order gets executed
    # @return [Number]
    attr_accessor :execution_day

    # The interval the standing order gets executed (possible values are weekly, monthly,
    # two monthly, quarterly, half yearly and yearly)
    # @return [String]
    attr_accessor :interval

    # Account number recipient
    # @return [String]
    attr_accessor :account_number

    # Bank code of recipient
    # @return [String]
    attr_accessor :bank_code

    # Bank name of recipient
    # @return [String]
    attr_accessor :bank_name

    # Standing order amount
    # @return [Number]
    attr_accessor :amount

    # Three-character currency code
    # @return [String]
    attr_accessor :currency

    # Purpose text (this field might be empty if the standing order has no purpose)
    # @return [String]
    attr_accessor :purpose

    # Internal creation timestamp on the figo Connect server
    # @return [Date]
    attr_accessor :creation_timestamp

    # Internal modification timestamp on the figo
    # @return [Date]
    attr_accessor :modification_timestamp
  end
end

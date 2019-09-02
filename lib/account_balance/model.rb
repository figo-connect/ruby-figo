# frozen_string_literal: true

require_relative '../base.rb'
module Figo
  # Object representing the balance of a certain bank account of the User
  class AccountBalance < Base
    @dump_attributes = %i[credit_line monthly_spending_limit]

    def initialize(session, json)
      super(session, json)
    end

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
end

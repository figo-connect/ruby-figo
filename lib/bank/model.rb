# frozen_string_literal: true

require_relative '../base.rb'
module Figo
  # Object representing a bank, i.e. an connection to a bank
  class Bank < Base
    @dump_attributes = [:sepa_creditor_id]

    def initialize(session, json)
      super(session, json)
    end

    # Internal figo Connect bank ID
    # @return [String]
    attr_accessor :bank_id

    # SEPA direct debit creditor ID
    # @return [String]
    attr_accessor :sepa_creditor_id

    # This flag indicates whether the user has chosen to save the PIN on the figo Connect server
    # @return [Boolean]
    attr_accessor :save_pin
  end
end

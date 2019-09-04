# frozen_string_literal: true

require_relative '../bank/model'
require_relative '../base'

module Figo
  # Object representing a Catalog of Banks and Services
  class Catalog < Base
    @dump_attributes = %i[banks services]

    def initialize(session, hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
    end

    # List of banks
    # @return [Array]
    attr_reader :banks
    def banks=(array)
      @banks = array.map { |hash| Figo::Bank.new(hash) }
    end

    # List of services
    # @return [Array]
    attr_accessor :services
  end
end

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
      end unless hash.nil? || hash.empty?
    end

    # @return [Array] List of banks
    attr_reader :banks
    def banks=(array)
      @banks = array.map { |hash| Figo::Bank.new(hash) }
    end

    # @return [Array] List of services
    attr_reader :services
    def services=(array)
      @services = array.map { |hash| Figo::Service.new(hash) }
    end
  end
end

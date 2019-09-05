# frozen_string_literal: true

require_relative '../bank/model'
require_relative '../base'

module Figo
  # Object representing a Catalog of Banks and Services
  class Catalog < Base
    @dump_attributes = %i[banks services]

    def initialize(_session, hash)
      unless hash.nil? || hash.empty?
        hash.keys.each do |key|
          send("#{key}=", hash[key])
        end
      end
    end

    # @return [Array] List of banks
    attr_reader :banks
    def banks=(array)
      @banks = array.map { |hash| Figo::Bank.new(nil, hash) }
    end

    # @return [Array] List of services
    attr_reader :services
    def services=(array)
      @services = array.map { |hash| Figo::Service.new(nil, hash) }
    end
  end
end

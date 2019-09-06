# frozen_string_literal: true
require_relative 'base'
require_relative 'bank'

module Figo
  module Model
    # Object representing a Catalog of Banks and Services
    class Catalog < Base
      # @return [Array] List of banks
      attr_reader :banks
      def banks=(array)
        @banks = array.map { |hash| Bank.new(nil, hash) }
      end

      # @return [Array] List of services
      attr_reader :services
      def services=(array)
        @services = array.map { |hash| Service.new(nil, hash) }
      end
    end
  end
end
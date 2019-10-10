# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    # Object representing the bank server synchronization status
    class SynchronizationStatus < Base
      # Internal figo Connect status code
      # @return [Integer]
      attr_accessor :code

      # Human-readable error message
      # @return [String]
      attr_accessor :message

      # Timestamp of last synchronization
      # @return [DateTime]
      attr_accessor :sync_timestamp

      # Timestamp of last successful synchronization
      # @return [DateTime]
      attr_accessor :success_timestamp
    end
  end
end
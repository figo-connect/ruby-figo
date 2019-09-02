# frozen_string_literal: true

require_relative '../base.rb'
module Figo
  # Object representing the bank server synchronization
  class Sync < Base
    @dump_attributes = []

    # Internal figo id of synchronization
    # @return [String]
    attr_accessor :id

    # Synchronization status
    # @return [String]
    attr_accessor :status

    # Challenge of synchronization
    # @return [Challenge]
    attr_accessor :challenge

    # Error synchronization
    # @return [Error]
    attr_accessor :error

    # Timestamp of synchronization
    # @return [DateTime]
    attr_accessor :created_at
    attr_accessor :started_at
    attr_accessor :ended_at
  end
end

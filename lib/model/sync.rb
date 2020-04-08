# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    # Object representing the bank server synchronization
    class Sync < Base
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

      # Synchronization type
      # @return [String]
      attr_accessor :type

      # redirect_uri of synchronization
      # @return [String]
      attr_accessor :redirect_uri

      # Timestamp of synchronization
      # @return [DateTime]
      attr_accessor :created_at
      attr_accessor :started_at
      attr_accessor :ended_at
    end
  end
end
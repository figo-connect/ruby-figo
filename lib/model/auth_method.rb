# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    # Object representing the bank server synchronization status
    class AuthMethod < Base
      DUMP_ATTRIBUTES = %i[
        id medium_name type additional_info
      ]

      def initialize(hash)
        super(nil, hash)
      end

      # figo ID of TAN scheme.
      # @return [String](TANSchemeID)
      attr_accessor :id

      # Description of the medium used to generate the authentication response.
      # @return [String]
      attr_accessor :medium_name

      # Type of authentication method.
      # @return [String]
      attr_accessor :type

      # Additional information on the authentication method as key/value pairs.
      # @return [String]
      attr_accessor :additional_info
    end
  end
end
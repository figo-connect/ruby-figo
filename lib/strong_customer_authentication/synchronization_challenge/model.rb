# frozen_string_literal: true

require_relative '../../base.rb'
module Figo
  # Object representing the bank server synchronization status
  class SynchronizationChallenge < Base
    @dump_attributes = %i[
      id created_at type auth_methods format version data
      additional_info label input_format max_length
      min_length location message
    ]

    # figo ID of the challenge.
    # @return [String]
    attr_accessor :id

    # Time at which the challenge was created.
    # @return [String]<ISO 8601>
    attr_accessor :created_at

    # Figo ID of the challenge.
    # @return [String]
    attr_accessor :type

    # Array of objects (AuthMethod)
    # @return [Array<AuthMethod>]
    attr_reader :auth_methods
    def auth_methods=(hash)
      AuhtMethodhash.new(hash.delete_if { |_, v| v.nil? })
    end

    # Indicates how the data field should be interpreted.
    # @return [String] (Enum: "PHOTO" "HHD" "TEXT" "HTML")
    attr_accessor :format

    # The version of the used challenge type. Left empty if it does not apply.
    # @return [String]
    attr_accessor :version

    # The format of the data is specified in the format field.
    # @return [String]
    attr_accessor :data

    # Provides additional information text to be displayed to the end-user.
    # @return [String]
    attr_accessor :additional_info

    # To be used as label for the user input field in UIs.
    # @return [String]
    attr_accessor :label

    # The expected input format or type for the response to the challenge.
    # @return [String]
    attr_accessor :input_format

    # Maximum length of the response to be provided to the challenge.
    # @return [Integer]
    attr_accessor :max_length

    # Maximum length of the response to be provided to the challenge.
    # @return [Integer]
    attr_accessor :min_length

    # The URI to which the end user is redirected in OAuth cases.
    # @return [String]
    attr_accessor :location

    # Instructional text to be displayed to the end-user.
    # @return [String]
    attr_accessor :message
  end
end

# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    # Object representing one access of the User
    class Access < Base
      DUMP_ATTRIBUTES = %i[id consent auth_methods access_method_id selected_auth_method created_at].freeze
      # Figo ID of the access
      # @return [String]
      attr_accessor :id

      # Configuration of the PSD2 consents. Is ignored for non-PSD2 accesses.
      # @return [Consent]
      attr_accessor :consent

      # Authentification methods associated with the access
      # @return [AuthMethods]
      attr_accessor :auth_methods

      # Selected authentification method
      # @return [AuthMethod]
      attr_accessor :selected_auth_method

      # Figo ID of the provider access method.
      # @return [String]
      attr_accessor :access_method_id

      # Timestamps of the access
      # return [Date]
      attr_accessor :created_at

      # Status of the access
      # return [Date]
      attr_accessor :status

      # save_pin flag of the access
      # return [Date]
      attr_accessor :save_pin

      # auto_sync flag of the access
      # return [Date]
      attr_accessor :auto_sync
    end
  end
end

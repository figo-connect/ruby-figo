require_relative "../base.rb"
module Figo
# Object representing one bank account of the User
  class Access < Base
    @dump_attributes = []

    def initialize(session, json)
      super(session, json)
    end

    # Figo ID of the access
    # @return [String]
    attr_accessor :id

    # Configuration of the PSD2 consents. Is ignored for non-PSD2 accesses.
    # @return [Consent]
    attr_accessor :consent

    # Authentification methods associated with the access
    # @return [AuthMethods]
    attr_accessor :auth_methods

    # Figo ID of the provider access method.
    # @return [String]
    attr_accessor :access_method_id

    # Timestamps of the access
    # return [Date]
    attr_accessor :created_at
  end
end

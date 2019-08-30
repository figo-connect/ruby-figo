require_relative "model.rb"
module Figo
  # Retrieve all accesses associated with account
  #
  # @return [Array] an array of `Access` objects, one for each access of the user
  def accesses
    query_api_object Access, "/rest/accesses", nil, "GET", "access"
  end

  # Create access associated with account
  #
  # @param access_method_id [String] ID of access method to create an access for
  # @param credentials [Object] Credentials used for authentication with the financial service provider.
  # @param consent [Object] Configuration of the PSD2 consents
  # @return [Access] access object created
  def add_access(access_method_id, credentials, consent)
    data = { "access_method_id": access_method_id, "credentials" : credentials, "consent": consent }
    query_api("/rest/accesses", data=data, method="POST")
  end

  # Retrieve specific access.
  #
  # @param access_id [String] ID of the access to be retrieved.
  # @return [Access] access object
  def get_access(access_id)
    query_api_object Access, "/rest/accesses/#{access_id}", method="GET"
  end

  # Remove stored PIN.
  #
  # @param access_id [String] ID of the access to remove the PIN for.
  # @return [Access] access object
  def remove_pin(access_id)
    query_api "/rest/accesses/#{access_id}/remove_pin", nil, "DELETE"
  end
end

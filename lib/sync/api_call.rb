require_relative "model.rb"
module Figo
  # Start provider synchronization
  #
  # @param access_id [String] Figo ID of the access
  # @param disable_notifications [Boolean] This flag indicates whether notifications should be sent to your application, default: False
  # @param redirect_uri [String] The URI to which the end user is redirected in OAuth cases, Optional
  # @param state [String] An arbitrary string to maintain state between this request and the callback, Optional
  # @param credentials [Object] Credentials used for authentication with the financial service provider, Optional
  # @param save_secret [Boolean] Indicates whether the confidential parts of the credentials should be saved, Defaulf: False
  # @return [Object] The Sync created with requested params
  def add_sync(access_id, disable_notifications=false, redirect_uri=nil, state=nil, credentials=nil, save_secret=false)
    data = {
      disable_notifications: disable_notifications,
      redirect_uri: redirect_uri,
      state: state,
      cedentials: cendentials,
      save_secret: save_secret
    }.delete_if { |k, v| v.nil? }

    query_api_object Sync, "rest/accesses/#{access_id}/syncs", data=data, method="POST"
  end

  # Get synchronization status
  #
  # @param access_id [String] Figo ID of the access associated with the sync
  # @param sync_id [String] Figo ID of the sync to get
  # @return [Object] The Sync created with requested params
  def get_synchronisation_status(access_id, sync_id)
    query_api_object Sync, "rest/accesses/#{access_id}/syncs/#{sync_id}", method="GET"
  end
end
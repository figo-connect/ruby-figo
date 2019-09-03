# frozen_string_literal: true

require_relative 'model.rb'
module Figo
  # Retrieve the URL a user should open in the web browser to start the synchronization process.
  #
  # @param redirect_uri [String] The user will be redirected to this URL after the sync process completes.
  # @param state [String] This string will be passed on through the complete synchronization process
  # @return [String] The result parameter is the URL to be opened by the user.
  def get_sync_url(redirect_uri, state)
    data = { redirect_uri: redirect_uri, state: state }.to_query
    res = query_api '/rest/sync', data, 'POST'

    "https://#{API_ENDPOINT}/task/start?id=#{res['task_token']}"
  end

  # Retrieve the URL a user should open in the web browser to start the synchronization process.
  #
  # @param redirect_uri [String] the user will be redirected to this URL after the process completes
  # @param state [String] this string will be passed on through the complete synchronization process
  #        and to the redirect target at the end. It should be used to validated the authenticity of
  #        the call to the redirect URL
  # @param if_not_synced_since [Integer] if this parameter is set, only those accounts will be
  #        synchronized, which have not been synchronized within the specified number of minutes.
  # @return [String] the URL to be opened by the user.
  def sync_url(redirect_uri, state, if_not_synced_since)
    data = { redirect_uri: redirect_uri, state: state, if_not_synced_since: if_not_synced_since }.to_query
    response = query_api '/rest/sync', data, 'POST'
    "https://#{API_ENDPOINT}/task/start?id=#{response['task_token']}"
  end
end

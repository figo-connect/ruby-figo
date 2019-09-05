# frozen_string_literal: true

module Figo
  # Represents a non user-bound connection to the figo Connect API.
  # Its main purpose is to let user login via OAuth 2.0.
  class Connection
    include Figo
    # Create connection object with client credentials.
    #
    # @param client_id [String] the client ID
    # @param client_secret [String] the client secret
    # @param redirect_uri [String] optional redirect URI
    def initialize(client_id, client_secret, redirect_uri = nil)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @https = HTTPS.new("figo-#{client_id}", nil)
    end

    # Helper method for making a OAuth 2.0 request.
    #
    # @param path [String] the URL path on the server
    # @param data [Hash] this optional object will be used as url-encoded POST content.
    # @return [Hash] JSON response
    def query_api(path, data = nil, method = 'POST')
      uri = URI("https://#{API_ENDPOINT}#{path}")

      # Setup HTTP request.
      request = method == 'POST' ? Net::HTTP::Post.new(path) : Net::HTTP::Get.new(path)
      request.basic_auth(@client_id, @client_secret)
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request['User-Agent'] = 'figo-ruby/1.4.2'
      request.body = URI.encode_www_form(data) unless data.nil?

      # Send HTTP request.
      response = @https.request(uri, request)

      # Evaluate HTTP response.
      response.body && !response.body.empty? ? JSON.parse(response.body) : nil
    end

    def query_api_object(type, path, data = nil, method = 'GET') # :nodoc:
      response = query_api path, data, method
      return nil if response.nil?

      type.new(self, response)
    end

    def get_version
      query_api '/version', nil, 'GET'
    end
  end
end

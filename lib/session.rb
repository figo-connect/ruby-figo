require_relative 'access/api_call'
require_relative 'access/model'
require_relative 'account/api_call'
require_relative 'account/model'
require_relative 'account_balance/api_call'
require_relative 'account_balance/model'
require_relative 'bank/api_call'
require_relative 'bank/model'
require_relative 'notification/api_call'
require_relative 'notification/model'
require_relative 'payment/api_call'
require_relative 'payment/model'
require_relative 'security/api_call'
require_relative 'security/model'
require_relative 'standing_order/api_call'
require_relative 'standing_order/model'
require_relative 'strong_customer_authentication/api_call'
require_relative 'strong_customer_authentication/auth_method/model'
require_relative 'strong_customer_authentication/synchronization_challenge/model'
require_relative 'sync/api_call'
require_relative 'sync/model'
require_relative 'synchronization_status/api_call'
require_relative 'synchronization_status/model'
require_relative 'task/api_call'
require_relative 'task/model'
require_relative 'transaction/api_call'
require_relative 'transaction/model'
require_relative 'user/api_call'
require_relative 'user/model'

module Figo
  # Represents a user-bound connection to the figo Connect API and allows access to the user's data.
  class Session
    include Figo
    # Create session object with access token.
    #
    # @param access_token [String] the access token
    def initialize(access_token)
      @access_token = access_token
      @https = HTTPS.new("figo-#{access_token}", nil)
    end

    # Helper method for making a REST request.
    #
    # @param path [String] the URL path on the server
    # @param data [hash] this optional object will be used as JSON-encoded POST content.
    # @param method [String] the HTTP method
    # @return [Hash] JSON response
    def query_api(path, data = nil, method = 'GET') # :nodoc:
      uri = URI("https://#{API_ENDPOINT}#{path}")

      # Setup HTTP request.
      request = case method
                when 'POST'
                  Net::HTTP::Post.new(path)
                when 'PUT'
                  Net::HTTP::Put.new(path)
                when 'DELETE'
                  Net::HTTP::Delete.new(path)
                else
                  Net::HTTP::Get.new(path)
                end

      request['Authorization'] = "Bearer #{@access_token}"
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'application/json'
      request['User-Agent'] = 'figo-ruby/1.4.2'

      request.body = JSON.generate(data) unless data.nil?

      # Send HTTP request.
      response = @https.request(uri, request)

      # Evaluate HTTP response.
      return nil if response.nil? || response.body.nil? || response.body.empty?

      JSON.parse(response.body)
    end

    def query_api_object(type, path, data = nil, method = 'GET', array_name = nil) # :nodoc:
      response = query_api path, data, method
      return nil if response.nil?
      return type.new(self, response) if array_name.nil?

      response[array_name].map { |entry| type.new(self, entry) }
    end
  end
end
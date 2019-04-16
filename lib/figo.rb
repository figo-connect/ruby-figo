#
# Copyright (c) 2013 figo GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require "json"
require "yaml"

require_relative "./helpers/https.rb"
require_relative "./helpers/error.rb"

require_relative "./authentification/api_call.rb"

# Ruby bindings for the figo Connect API: http://developer.figo.me
module Figo
  $config = YAML.load_file(File.join(__dir__, '../config.yml'))
  $api_endpoint = $config["API_ENDPOINT"]

  # Represents a non user-bound connection to the figo Connect API.
  #
  # It's main purpose is to let user login via OAuth 2.0.
  class Connection
    include Figo
    # Create connection object with client credentials.
    #
    # @param client_id [String] the client ID
    # @param client_secret [String] the client secret
    # @param redirect_uri [String] optional redirect URI
    def initialize(client_id, client_secret, redirect_uri = nil, api_endpoint = $api_endpoint)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @https = HTTPS.new("figo-#{client_id}", nil)
      @api_endpoint = api_endpoint
    end

    # Helper method for making a OAuth 2.0 request.
    #
    # @param path [String] the URL path on the server
    # @param data [Hash] this optional object will be used as url-encoded POST content.
    # @return [Hash] JSON response
    def query_api(path, data = nil)
      uri = URI("https://#{@api_endpoint}#{path}")

      # Setup HTTP request.
      request = Net::HTTP::Post.new(path)
      request.basic_auth(@client_id, @client_secret)
      request["Accept"] = "application/json"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request["User-Agent"] =  "figo-ruby/1.3.1"
      request.body = URI.encode_www_form(data) unless data.nil?

      # Send HTTP request.
      response = @https.request(uri, request)

      # Evaluate HTTP response.
      return response.body == "" ? {} : JSON.parse(response.body)
    end
  end

  # Represents a user-bound connection to the figo Connect API and allows access to the user's data.
  class Session
    require_relative "./account_balance/model.rb"
    require_relative "./account_balance/api_call.rb"

    require_relative "./account/model.rb"
    require_relative "./account/api_call.rb"

    require_relative "./bank/model.rb"
    require_relative "./bank/api_call.rb"

    require_relative "./notification/model.rb"
    require_relative "./notification/api_call.rb"

    require_relative "./payment/model.rb"
    require_relative "./payment/api_call.rb"

    require_relative "./synchronization_status/model.rb"
    require_relative "./synchronization_status/api_call.rb"

    require_relative "./transaction/model.rb"
    require_relative "./transaction/api_call.rb"

    require_relative "./user/model.rb"
    require_relative "./user/api_call.rb"

    require_relative "./standing_order/model.rb"
    require_relative "./standing_order/api_call.rb"

    require_relative "./process/model.rb"
    require_relative "./process/api_call.rb"

    require_relative "./security/model.rb"
    require_relative "./security/api_call.rb"

    require_relative "./task/model.rb"
    require_relative "./task/api_call.rb"

    include Figo

    # Create session object with access token.
    #
    # @param access_token [String] the access token
    def initialize(access_token, api_endpoint = $api_endpoint)
      @access_token = access_token
      @https = HTTPS.new("figo-#{access_token}", nil)
      @api_endpoint = api_endpoint
    end

    # Helper method for making a REST request.
    #
    # @param path [String] the URL path on the server
    # @param data [hash] this optional object will be used as JSON-encoded POST content.
    # @param method [String] the HTTP method
    # @return [Hash] JSON response
    def query_api(path, data=nil, method="GET") # :nodoc:
      uri = URI("https://#{@api_endpoint}#{path}")

      # Setup HTTP request.
      request = case method
        when "POST"
          Net::HTTP::Post.new(path)
        when "PUT"
          Net::HTTP::Put.new(path)
        when "DELETE"
          Net::HTTP::Delete.new(path)
        else
          Net::HTTP::Get.new(path)
      end

      request["Authorization"] = "Bearer #{@access_token}"
      request["Accept"] = "application/json"
      request["Content-Type"] = "application/json"
      request["User-Agent"] =  "figo-ruby/1.3.1"

      request.body = JSON.generate(data) unless data.nil?

      # Send HTTP request.
      response = @https.request(uri, request)

      # Evaluate HTTP response.
      return nil if response.nil?
      return nil if response.body.nil?
      return response.body == "" ? nil : JSON.parse(response.body)
    end

    def query_api_object(type, path, data=nil, method="GET", array_name=nil) # :nodoc:
      response = query_api path, data, method
      return nil if response.nil?
      return type.new(self, response) if array_name.nil?
      return response[array_name].map {|entry| type.new(self, entry)}
    end
  end
end

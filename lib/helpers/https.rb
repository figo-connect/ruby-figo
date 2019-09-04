# frozen_string_literal: true

require 'net/http/persistent'

module Figo
  # HTTPS class with certificate authentication and enhanced error handling.
  class HTTPS < Net::HTTP::Persistent
    # Overwrite `initialize` method from `Net::HTTP::Persistent`.
    def initialize(name = nil, proxy = nil)
      super(name: name, proxy: proxy)
    end

    # Overwrite `request` method from `Net::HTTP::Persistent`.
    #
    # Raise error when a REST API error is returned.
    def request(uri, req = nil, &block)
      response = super(uri, req, &block)

      # Evaluate HTTP response.
      case response
      when Net::HTTPSuccess
        return response
      when Net::HTTPBadRequest
        parsed_response = JSON.parse(response.body)
        raise Error.new(parsed_response['error'], parsed_response['error']['description'])
      when Net::HTTPUnauthorized
        raise Error.new('unauthorized', 'Missing, invalid or expired access token.')
      when Net::HTTPForbidden
        raise Error.new('forbidden', 'Insufficient permission.')
      when Net::HTTPNotFound
        return nil
      when Net::HTTPMethodNotAllowed
        raise Error.new('method_not_allowed', 'Unexpected request method.')
      when Net::HTTPServiceUnavailable
        raise Error.new('service_unavailable', 'Exceeded rate limit.')
      else
        parsed_response = JSON.parse(response.body)
        raise Error.new(parsed_response['error'], parsed_response['error']['description'])
      end
    end
  end
end

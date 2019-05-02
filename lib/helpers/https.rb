require "net/http/persistent"
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
          hash = JSON.parse(response.body)
          raise Error.new(hash["error"], hash["error"]["description"])
        when Net::HTTPUnauthorized
          raise Error.new("unauthorized", "Missing, invalid or expired access token.")
        when Net::HTTPForbidden
          raise Error.new("forbidden", "Insufficient permission.")
        when Net::HTTPNotFound
          return nil
        when Net::HTTPMethodNotAllowed
          raise Error.new("method_not_allowed", "Unexpected request method.")
        when Net::HTTPServiceUnavailable
          raise Error.new("service_unavailable", "Exceeded rate limit.")
        else
          raise Error.new("internal_server_error", "We are very sorry, but something went wrong.")
      end
    end
  end
end

require "net/http/persistent"
module Figo
  # HTTPS class with certificate authentication and enhanced error handling.
  class HTTPS < Net::HTTP::Persistent
    # Overwrite `initialize` method from `Net::HTTP::Persistent`.
    #
    # Verify fingerprints of server SSL/TLS certificates.
    def initialize(name = nil, proxy = nil)
      super(name, proxy)

      # Attribute ca_file must be set, otherwise verify_callback would never be called.
      @ca_file = "lib/cacert.pem"
      @verify_callback = proc do |preverify_ok, store_context|
        if preverify_ok and store_context.error == 0
          certificate = OpenSSL::X509::Certificate.new(store_context.chain[0])
          fingerprint = Digest::SHA1.hexdigest(certificate.to_der).upcase.scan(/../).join(":")
          $valid_fingerprints.include?(fingerprint)
        else
          false
        end
      end
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

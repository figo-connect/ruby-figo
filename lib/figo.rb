require "json"
require "logger"
require 'net/http/persistent'
require "digest/sha1"
require "./lib/models.rb"

$logger = Logger.new(STDOUT)

module Figo

  API_ENDPOINT = "api.leanbank.com"

  VALID_FINGERPRINTS = ["A6:FE:08:F4:A8:86:F9:C1:BF:4E:70:0A:BD:72:AE:B8:8E:B7:78:52",
                        "AD:A0:E3:2B:1F:CE:E8:44:F2:83:BA:AE:E4:7D:F2:AD:44:48:7F:1E"]

  class Error < RuntimeError

    def initialize(error, error_description) # :nodoc:
      @error = error
      @error_description = error_description
    end

    def to_s # :nodoc:
      return @error_description
    end

  end

  class HTTPS < Net::HTTP::Persistent # :nodoc:

    def initialize(name = nil, proxy = nil)
      super(name, proxy)

      # Attribute ca_file must be set, otherwise verify_callback would never be called.
      @ca_file = ""
      @verify_callback = proc do |preverify_ok, store_context|
        if preverify_ok and store_context.error == 0
          certificate = OpenSSL::X509::Certificate.new(store_context.chain[0])
          fingerprint = Digest::SHA1.hexdigest(certificate.to_der).upcase.scan(/../).join(":")
          VALID_FINGERPRINTS.include?(fingerprint)
        else
          false
        end
      end
    end

    def request(uri, req = nil, &block)
      response = super(uri, req, &block)

      # Evaluate HTTP response.
      case response
        when Net::HTTPSuccess
          return response
        when Net::HTTPBadRequest
          hash = JSON.parse(response.body)
          raise Error.new(hash["error"], hash["error_description"])
        when Net::HTTPUnauthorized
          raise Error.new("unauthorized", "Missing, invalid or expired access token.")
        when Net::HTTPForbidden
          raise Error.new("forbidden", "Insufficient permission.")
        when Net::HTTPNotFound
          raise Error.new("not_found", "Requested object does not exist.")
        when Net::HTTPMethodNotAllowed
          raise Error.new("method_not_allowed", "Unexpected request method.")
        when Net::HTTPServiceUnavailable
          raise Error.new("service_unavailable", "Exceeded rate limit.")
        else
          $logger.warn("Querying the API failed when accessing '#{path}': #{response.code}")
          raise Error.new("internal_server_error", "We are very sorry, but something went wrong.")
      end
    end

  end

  # Represents a non user-bound connection to the figo Connect API.
  class Connection

    # Create connection object with your client ID and client secret.
    def initialize(client_id, client_secret, redirect_uri = nil)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @https = HTTPS.new("figo-#{client_id}")
    end

    def query_api(path, data = nil) # :nodoc:
        uri = URI("https://#{API_ENDPOINT}#{path}")
        puts uri

        # Setup HTTP request.
        request = Net::HTTP::Post.new(path)
        request.basic_auth(@client_id, @client_secret)
        request["Content-Type"] = "application/x-www-form-urlencoded"
        request['User-Agent'] =  "ruby-figo"
        request.body = URI.encode_www_form(data) unless data.nil?

        # Send HTTP request.
        response = @https.request(uri, request)

        # Evaluate HTTP response.
        return response.body == "" ? {} : JSON.parse(response.body)
    end

    # Get the URL a user should open in the web browser to start the login process.
    def login_url(state, scope = nil)
      data = { "response_type" => "code", "client_id" => @client_id, "state" => state }
      data["redirect_uri"] = @redirect_uri unless @redirect_uri.nil?
      data["scope"] = scope unless scope.nil?
      return "https://#{API_ENDPOINT}/auth/code?" + URI.encode_www_form(data) 
    end

    # Exchange authorization code or refresh token for access token.
    def obtain_access_token(authorization_code_or_refresh_token, scope = nil)
      # Authorization codes always start with "O" and refresh tokens always start with "R".
      if authorization_code_or_refresh_token[0] == "O"
        data = { "grant_type" => "authorization_code", "code" => authorization_code_or_refresh_token }
        data["redirect_uri"] = @redirect_uri unless @redirect_uri.nil?
      elsif authorization_code_or_refresh_token[0] == "R"
        data = { "grant_type" => "refresh_token", "refresh_token" => authorization_code_or_refresh_token }
        data["scope"] = scope unless scope.nil?
      end
      return query_api("/auth/token", data)
    end

    # Revoke refresh token or access token.
    def revoke_token(refresh_token_or_access_token)
      data = { "token" => refresh_token_or_access_token }
      query_api("/auth/revoke?" + URI.encode_www_form(data))
      return nil
    end

  end

  # Represents a user-bound connection to the figo Connect API and allows access to the user's data.
  class Session

    # Create session object with access token.
    def initialize(access_token)
      @access_token = access_token
      @https = HTTPS.new("figo-#{access_token}")
    end

    def query_api(path, data=nil, method="GET") # :nodoc:
      uri = URI("https://#{API_ENDPOINT}#{path}")

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
      request["Content-Type"] = "application/json"
      request['User-Agent'] =  "ruby-figo"
      request.body = JSON.generate(data) unless data.nil?

      # Send HTTP request.
      response = @https.request(uri, request)

      # Evaluate HTTP response.
      return response.body == "" ? {} : JSON.parse(response.body)
    end

    # Request list of accounts.
    def accounts
      response = query_api("/rest/accounts")
      return response["accounts"].map {|account| Account.new(self, account)}
    end

    # Request specific account.
    def get_account(account_id)
      response = query_api("/rest/accounts/#{account_id}")
      return Account.new(self, response)
    end

    # Request list of transactions.
    def transactions(since = nil, start_id = nil, count = 1000, include_pending = false)
      data = {}
      data["since"] = (since.is_a?(Date) ? since.to_s : since) unless since.nil?
      data["start_id"] = start_id unless start_id.nil?
      data["count"] = count.to_s
      data["include_pending"] = include_pending ? "1" : "0"
      response = query_api("/rest/transactions?" + URI.encode_www_form(data)) 
      return response["transactions"].map {|transaction| Transaction.new(self, transaction)}
    end

    # Request the URL a user should open in the web browser to start the synchronization process.
    def sync_url(redirect_uri, state, disable_notifications = false, if_not_synced_since = 0)
      disable_notifications = disable_notifications ? "1" : "0"
      if_not_synced_since = if_not_synced_since.to_s
      data = { "redirect_uri" => redirect_uri, "state" => state, "disable_notifications" => disable_notifications, "if_not_synced_since" => if_not_synced_since }
      response = query_api("/rest/sync", data, "POST")
      return "https://#{API_ENDPOINT}/task/start?id=#{response["task_token"]}"
    end

    # Request list of registered notifications.
    def notifications
      response = query_api("/rest/notifications")
      return response["notifications"].map {|notification| Notification.new(self, notification)}
    end

    # Register notification.
    def add_notification(observe_key, notify_uri, state)
      data = { "observe_key" => observe_key, "notify_uri" => notify_uri, "state" => state }
      response = query_api("/rest/notifications", data, "POST")
      return response["notification_id"]
    end

    # Unregister notification.
    def remove_notification(notification_id)
      query_api("/rest/notifications/#{notification_id}", nil, "DELETE")
      return nil
    end

  end

end

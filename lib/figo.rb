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
require "net/http/persistent"
require "digest/sha1"
require_relative "models.rb"


# Ruby bindings for the figo Connect API: http://developer.figo.me
module Figo
  $api_endpoint = "api.figo.me"

  $valid_fingerprints = ["3A:62:54:4D:86:B4:34:38:EA:34:64:4E:95:10:A9:FF:37:27:69:C0",
                         "CF:C1:BC:7F:6A:16:09:2B:10:83:8A:B0:22:4F:3A:65:D2:70:D7:3E"]

  # Base class for all errors transported via the figo Connect API.
  class Error < RuntimeError
    # Initialize error object.
    #
    # @param error [String] the error code
    # @param error_description [String] the error description
    def initialize(error, error_description)
      @error = error
      @error_description = error_description
    end

    # Convert error object to string.
    #
    # @return [String] the error description
    def to_s
      return @error_description
    end
  end

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
          raise Error.new(hash["error"], hash["error_description"])
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

  # Represents a non user-bound connection to the figo Connect API.
  #
  # It's main purpose is to let user login via OAuth 2.0.
  class Connection
    # Create connection object with client credentials.
    #
    # @param client_id [String] the client ID
    # @param client_secret [String] the client secret
    # @param redirect_uri [String] optional redirect URI
    def initialize(client_id, client_secret, redirect_uri = nil)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @https = HTTPS.new("figo-#{client_id}")
    end

    # Helper method for making a OAuth 2.0 request.
    #
    # @param path [String] the URL path on the server
    # @param data [Hash] this optional object will be used as url-encoded POST content.
    # @return [Hash] JSON response
    def query_api(path, data = nil)
      uri = URI("https://#{$api_endpoint}#{path}")

      # Setup HTTP request.
      request = Net::HTTP::Post.new(path)
      request.basic_auth(@client_id, @client_secret)
      request["Accept"] = "application/json"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request["User-Agent"] =  "ruby-figo"
      request.body = URI.encode_www_form(data) unless data.nil?

      # Send HTTP request.
      response = @https.request(uri, request)

      # Evaluate HTTP response.
      return response.body == "" ? {} : JSON.parse(response.body)
    end


    # Get the URL a user should open in the web browser to start the login process.
    #
    # When the process is completed, the user is redirected to the URL provided to
    # the constructor and passes on an authentication code. This code can be converted
    # into an access token for data access.
    #
    # @param state [String] this string will be passed on through the complete login
    #        process and to the redirect target at the end. It should be used to
    #        validated the authenticity of the call to the redirect URL
    # @param scope [String] optional scope of data access to ask the user for,
    #        e.g. `accounts=ro`
    # @return [String] the URL to be opened by the user.
    def login_url(state, scope = nil)
      data = { "response_type" => "code", "client_id" => @client_id, "state" => state }
      data["redirect_uri"] = @redirect_uri unless @redirect_uri.nil?
      data["scope"] = scope unless scope.nil?
      return "https://#{$api_endpoint}/auth/code?" + URI.encode_www_form(data)
    end



    # Trying to login a user using their credentials +username+ and +password+. 
    # Upon successful login, the returned json contains an :access token.
    # @param username [String] the username (typically an eMail) of the user. 
    # @param password [String] the password of the user. 
    # @return [Hash] object with the keys `access_token`, `refresh_token` and
    #        `expires`, as documented in the figo Connect API specification.
    def credential_login(username, password)
      credential_login_request = { "grant_type" => "password", 
                                   "username" => username,
                                   "password" => password }
      return query_api("/auth/token", credential_login_request)
    end

    # Exchange authorization code or refresh token for access token.
    #
    # @param authorization_code_or_refresh_token [String] either the authorization
    #        code received as part of the call to the redirect URL at the end of the
    #        logon process, or a refresh token
    # @param scope [String] optional scope of data access to ask the user for,
    #        e.g. `accounts=ro`
    # @return [Hash] object with the keys `access_token`, `refresh_token` and
    #        `expires`, as documented in the figo Connect API specification.
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
    #
    # @note this action has immediate effect, i.e. you will not be able use that token anymore after this call.
    #
    # @param refresh_token_or_access_token [String] access or refresh token to be revoked
    # @return [nil]
    def revoke_token(refresh_token_or_access_token)
      data = { "token" => refresh_token_or_access_token }
      query_api("/auth/revoke?" + URI.encode_www_form(data))
      return nil
    end

    # Create a new figo Account
    #
    # @param name [String] First and last name
    # @param email [String] Email address; It must obey the figo username & password policy
    # @param password [String] New figo Account password; It must obey the figo username & password policy
    # @param language [String] Two-letter code of preferred language
    # @param send_newsletter [Boolean] This flag indicates whether the user has agreed to be contacted by email -- Not accepted by backend at the moment
    # @return [Hash] object with the key `recovery_password` as documented in the figo Connect API specification
    def create_user(name, email, password, language='de', send_newsletter=true)
        data = { 'name' => name, 'email' => email, 'password' => password, 'language' => language, 'affiliate_client_id' => @client_id} #'send_newsletter' => send_newsletter, 
        return query_api("/auth/user", data)
    end
  end

  # Represents a user-bound connection to the figo Connect API and allows access to the user's data.
  class Session

    # Create session object with access token.
    #
    # @param access_token [String] the access token
    def initialize(access_token)
      @access_token = access_token
      @https = HTTPS.new("figo-#{access_token}")
    end

    # Helper method for making a REST request.
    #
    # @param path [String] the URL path on the server
    # @param data [hash] this optional object will be used as JSON-encoded POST content.
    # @param method [String] the HTTP method
    # @return [Hash] JSON response
    def query_api(path, data=nil, method="GET") # :nodoc:
      uri = URI("https://#{$api_endpoint}#{path}")

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
      request["User-Agent"] =  "ruby-figo"
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

    # Retrieve current User
    #
    # @return [User] the current user
    def user
      query_api_object User, "/rest/user"
    end

    # Modify the current user
    #
    # @param user [User] the modified user object to be saved
    # @return [User] the modified user returned
    def modify_user(user)
      query_api_object User, "/rest/user", user.dump(), "PUT"
    end

    # Remove the current user
    # Note: this has immidiate effect and you wont be able to interact with the user after this call
    def remove_user
      query_api "/rest/user", nil, "DELETE"
    end

    # Retrieve all accounts
    #
    # @return [Array] an array of `Account` objects, one for each account the user has granted the app access
    def accounts
      query_api_object Account, "/rest/accounts", nil, "GET", "accounts"
    end

    # Retrieve specific account.
    #
    # @param account_id [String] ID of the account to be retrieved.
    # @return [Account] account object
    def get_account(account_id)
      query_api_object Account, "/rest/accounts/#{account_id}"
    end

    # Adds a new bank account for the user of the current session.
    #
    # @param bank_code [String] bank code. 
    # @param credentials [Array] list of login credential strings whose order must match with the order the credential list from the corresponding login settings.
    # @param country [String] two letter country code.
    # @param options [Hash] can contain optional key-value pairs such as values for 'bank_code', 'iban' etc.
    # @return [String] An immediate task token.
    def setup_new_bank_account(bank_code, credentials, country = 'de', options = {})
      data = { "bank_code" => bank_code,
               "country" => country,
               "credentials" => credentials
      }
      data = data.merge(options)
      query_api "/rest/accounts", data, "POST"
    end

    # Modify specific account
    #
    # @param account [Account] modified account to be saved
    # @return [Account] modified account returned by the server
    def modify_account(account)
      query_api_object Account, "/rest/accounts/#{account.account_id}", account.dump(), "PUT"
    end

    # Remove specific account
    #
    # @param account [Account, String] the account to be removed or its ID
    def remove_account(account)
      query_api account.is_a?(String) ? "/rest/accounts/#{account}" : "/rest/accounts/#{account.account_id}", nil, "DELETE"
    end

    # Retrieve balance of an account.
    #
    # @return [AccountBalance] account balance object
    def get_account_balance(account_id)
      query_api_object AccountBalance, "/rest/accounts/#{account_id}/balance"
    end

    # Modify balance or account limits
    #
    # @param account_id [String] ID of the account which balance should be modified
    # @param account_balance [AccountBalance] modified AccountBalance to be saved
    # @return [AccountBalance] modified AccountBalance returned by server
    def modify_account_balance(account_id, account_balance)
      query_api_object AccountBalance, "/rest/accounts/#{account_id}/balance", account_balance.dump(), "PUT"
    end

    # Retrieve specific bank
    #
    # @return [Bank] bank object
    def get_bank(bank_id)
      query_api_object Bank, "/rest/banks/#{bank_id}"
    end

    # Modify bank
    #
    # @param bank [Bank] modified bank object
    # @return [Bank] modified bank object returned by server
    def modify_bank(bank)
      query_api_object Bank, "/rest/banks/#{bank.bank_id}", bank.dump(), "PUT"
    end

    # Remove stored PIN from bank
    #
    # @param bank [Bank, String] the bank whose stored PIN should be removed or its ID
    # @return [nil]
    def remove_bank_pin(bank)
      query_api bank.is_a?(String) ? "/rest/banks/#{bank}/submit": "/rest/banks/#{bank.bank_id}/submit", nil, "POST"
    end

    # Get bank information from standard bank code
    #
    # @param country_code [String]
    # @param bank_code [String] bank sort code (Bankleitzahl)
    # @return [Hash] JSON response
    def find_bank(bank_code, country_code)
      query_api "/rest/catalog/banks/#{country_code}/#{bank_code}"
    end

    # Retrieve list of transactions (on all or a specific account)
    #
    # @param account_id [String] ID of the account for which to list the transactions
    # @param since [String, Date] this parameter can either be a transaction ID or a date
    # @param count [Integer] limit the number of returned transactions
    # @param offset [Integer] which offset into the result set should be used to determin the first transaction to return (useful in combination with count)
    # @param include_pending [Boolean] this flag indicates whether pending transactions should be included
    #        in the response; pending transactions are always included as a complete set, regardless of
    #        the `since` parameter
    # @return [Array] an array of `Transaction` objects, one for each transaction of the user
    def transactions(account_id = nil, since = nil, count = 1000, offset = 0, include_pending = false)
      data = {"count" => count.to_s, "offset" => offset.to_s, "include_pending" => include_pending ? "1" : "0"}
      data["since"] = ((since.is_a?(Date) ? since.to_s : since) unless since.nil?)

      query_api_object Transaction, (account_id.nil? ? "/rest/transactions?" : "/rest/accounts/#{account_id}/transactions?") + URI.encode_www_form(data), nil, "GET", "transactions"
    end

    # Retrieve a specific transaction
    #
    # @param account_id [String] ID of the account on which the transaction occured
    # @param transaction_id [String] ID of the transaction to be retrieved
    # @return [Transaction] transaction object
    def get_transaction(account_id, transaction_id)
      query_api_object Transaction, "/rest/accounts/#{account_id}/transactions/#{transaction_id}"
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
    def sync_url(redirect_uri, state, if_not_synced_since = 0)
      response = query_api "/rest/sync", {"redirect_uri" => redirect_uri, "state" => state, "if_not_synced_since" => if_not_synced_since}, "POST"
      return "https://#{$api_endpoint}/task/start?id=#{response["task_token"]}"
    end

    # Retrieve list of registered notifications.
    #
    # @return [Notification] an array of `Notification` objects, one for each registered notification
    def notifications
      query_api_object Notification, "/rest/notifications", nil, "GET", "notifications"
    end

    # Retrieve specific notification.
    #
    # @param notification_id [String] ID of the notification to be retrieved
    # @return [Notification] `Notification` object for the respective notification
    def get_notification(notification_id)
      query_api_object Notification, "/rest/notifications/#{notification_id}"
    end

    # Register a new notification.
    #
    # @param notification [Notification] notification to be crated. It should not have a notification_id set.
    # @return [Notification] newly created `Notification` object
    def add_notification(notification)
      query_api_object Notification, "/rest/notifications", notification.dump(), "POST"
    end

    # Modify notification.
    #
    # @param notification [Notification] modified notification object
    # @return [Notification] modified notification returned by server
    def modify_notification(notification)
      query_api_object Notification, "/rest/notifications/#{notification.notification_id}", notification.dump(), "PUT"
    end

    # Unregister notification.
    #
    # @param notification [Notification, String] notification object which should be deleted or its ID
    def remove_notification(notification)
      query_api notification.is_a?(String) ? "/rest/notifications/#{notification}" : "/rest/notifications/#{notification.notification_id}", nil, "DELETE"
    end

    # Retrieve list of all payments (on all accounts or one)
    #
    # @param account_id [String] ID of the account for whicht to list the payments
    # @return [Payment] an array of `Payment` objects, one for each payment
    def payments(account_id = nil)
      query_api_object Payment, account_id.nil? ? "/rest/payments" : "/rest/accounts/#{account_id}/payments", nil, "GET", "payments"
    end

    # Retrieve specific payment.
    #
    # @param account_id [String] ID for the account on which the payment to be retrieved was created
    # @param payment_id [String] ID of the notification to be retrieved
    # @return [Payment] `Payment` object for the respective payment
    def get_payment(account_id, payment_id)
      query_api_object Payment, "/rest/accounts/#{account_id}/payments/#{payment_id}"
    end

    # Create new payment
    #
    # @param payment [Payment] payment object to be created. It should not have a payment_id set.
    # @return [Payment] newly created `Payment` object
    def add_payment(payment)
      query_api_object Payment, "/rest/accounts/#{payment.account_id}/payments", payment.dump(), "POST"
    end

    # Modify payment
    #
    # @param payment [Payment] modified payment object
    # @return [Payment] modified payment object
    def modify_payment(payment)
      query_api_object Payment, "/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}", payment.dump(), "PUT"
    end

    # Submit payment
    #
    # @param tan_scheme_id [String] TAN scheme ID of user-selected TAN scheme
    # @param state [String] Any kind of string that will be forwarded in the callback response message
    # @param redirect_uri [String] At the end of the submission process a response will be sent to this callback URL
    # @return [String] the URL to be opened by the user for the TAN process
    def submit_payment(payment, tan_scheme_id, state, redirect_uri = nil)
      params = {"tan_scheme_id" => tan_scheme_id, "state" => state}
      params['redirect_uri'] = redirect_uri unless redirect_uri.nil?

      response = query_api "/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}/submit", params, "POST"
      return "https://#{$api_endpoint}/task/start?id=#{response["task_token"]}"
    end


    # Get the current state of a task by ID. 
    #
    # @param token_id [String] Id of the task token whose state will be checked. 
    # @return [Hash] A JSON response that contains information such as 'is_erroneous' or 'is_ended' about the task. 
    def get_task_state(token_id)
      data = { 'id' => token_id }
      return query_api "/task/progress?id=" + token_id, data, "POST"
    end

    # Remove payment
    #
    # @param payment [Payment, String] payment object which should be removed
    def remove_payment(payment)
      query_api "/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}", nil, "DELETE"
    end
  end
end

module Figo
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


  # Exchange authorization code or refresh token for access token.
  #
  # @param authorization_code_or_refresh_token [String] either the authorization
  #        code received as part of the call to the redirect URL at the end of the
  #        logon process, or a refresh token
  # @param scope [String] optional scope of data access to ask the user for,
  #        e.g. `accounts=ro`
  # @return [Hash] object with the keys `access_token`, `refresh_token` and `expires`, as documented in the figo Connect API specification.
  def obtain_access_token(authorization_code_or_refresh_token, scope = nil)
    # Authorization codes always start with "O" and refresh tokens always start with "R".
    if authorization_code_or_refresh_token[0] == "O"
      data = { "grant_type" => "authorization_code", "code" => authorization_code_or_refresh_token }
      data["redirect_uri"] = @redirect_uri unless @redirect_uri.nil?
    elsif authorization_code_or_refresh_token[0] == "R"
      data = { "grant_type" => "refresh_token", "refresh_token" => authorization_code_or_refresh_token }
      data["scope"] = scope unless scope.nil?
    end
    query_api "/auth/token", data
  end

  # Revoke refresh token or access token.
  #
  # @note this action has immediate effect, i.e. you will not be able use that token anymore after this call.
  #
  # @param refresh_token_or_access_token [String] access or refresh token to be revoked
  # @return [nil]
  def revoke_token(refresh_token_or_access_token)
    data = { "token" => refresh_token_or_access_token }
    query_api "/auth/revoke", data
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
    query_api "/auth/user", data
  end

  # Re-send verification email
  #
  def resend_verification()
    query_api "/rest/user/resend_verification", nil, "POST"
  end

  # Return a Token dictionary which tokens are used for further API calls.
  #
  # @param username [String] figo username
  # @param password [String] figo password
  # @return The result parameter is an object with the keys `access_token`, `token_type`, `expires_in`, `refresh_token` and `scope` as documented in the figo Connect API specification.
  def credential_login(username, password, device_name = nil, device_type = nil, device_udid = nil, scope = nil)
    options = { grant_type: "password", username: username, password: password }

    options.device_name = device_name if (device_name)
    options.device_type = device_type if (device_type)
    options.device_udid = device_udid if (device_udid)
    options.scope = scope if (scope)

    query_api "/auth/token", options
  end

end

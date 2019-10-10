# frozen_string_literal: true

module Figo
  # Return a Token dictionary which tokens are used for further API calls.
  #
  # @param username [String] figo username
  # @param password [String] figo password
  # @return The result parameter is an object with the keys `access_token`, `token_type`,
  #   `expires_in`, `refresh_token` and `scope` as documented in the figo Connect API specification.
  def user_credential_request(username, password, scope = nil)
    options = { grant_type: 'password', username: username, password: password }
    options[:scope] = scope if scope

    query_api '/auth/token', options
  end

  # Return a Token dictionary which tokens are used for further API calls.
  #
  # @param refresh_token [String] figo refresh token
  # @param scope [String] scope
  # @return The result parameter is an object with the keys `access_token`, `token_type`,
  #   `expires_in`, `refresh_token` and `scope` as documented in the figo Connect API specification.
  def refresh_token_request(refresh_token, scope = nil)
    options = { grant_type: 'refresh_token', refresh_token: refresh_token, scope: scope }
    options[:scope] = scope if scope

    query_api '/auth/token', options
  end

  # Return a Token dictionary which tokens are used for further API calls.
  #
  # @param code [String] code
  # @param redirect_uri [String] redirect_uri
  # @return The result parameter is an object with the keys `access_token`, `token_type`,
  #   `expires_in`, `refresh_token` and `scope` as documented in the figo Connect API specification.
  def authorization_code_request(code, redirect_uri)
    options = { grant_type: 'authorization_code', code: code, redirect_uri: redirect_uri }
    options[:scope] = scope if scope

    query_api '/auth/token', options
  end

  # Revoke refresh token or access token.
  #
  # @note this action has immediate effect, i.e. you will not be able use that token anymore after this call.
  # @param refresh_token_or_access_token [String] access or refresh token to be revoked
  # @return [nil]
  def revoke_token(refresh_token_or_access_token)
    query_api '/auth/revoke', 'token': refresh_token_or_access_token
  end
end

# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  before { create_user }
  after { destroy_user }

  def test_user_credential_request
    response = figo_connection.user_credential_request(username, password)
    assert response['access_token']
    assert response['token_type']
  end

  def test_refresh_token_request
    refresh_token = figo_connection.user_credential_request(username, password)['refresh_token']
    response = figo_connection.refresh_token_request(refresh_token)
    assert response['access_token']
    assert response['token_type']
  end

  # Need an OAuth code
  # def test_authorization_code_request
  #   response = figo_connection.authorization_code_request(authorization_code, redirect_uri)
  #   assert response['access_token']
  #   assert response['token_type']
  # end

  def test_revoke_token
    refresh_token = figo_connection.user_credential_request(username, password)['refresh_token']
    figo_connection.revoke_token(refresh_token)
    assert_raises(Figo::Error) { figo_connection.refresh_token_request(refresh_token) }
  end
end

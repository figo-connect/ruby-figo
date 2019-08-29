# frozen_string_literal: true

require 'securerandom'

module Setup
  def setup
    @username = "#{SecureRandom.alphanumeric(8)}@test.com"
    @password = 'password'
    @client_id = 'CaESKmC8MAhNpDe5rvmWnSkRE_7pkkVIIgMwclgzGcQY'
    @client_secret = 'STdzfv0GXtEj_bwYn7AgCVszN1kKq5BdgEIKOM_fzybQ'
  end

  private

  attr_reader :username, :password, :client_id, :client_secret

  def access_token
    response = figo_connection.user_credential_request(username, password)
    response['access_token']
  end

  def figo_session
    @figo_session ||= Figo::Session.new(access_token)
  end

  def figo_connection
    @figo_connection ||= Figo::Connection.new(client_id, client_secret)
  end

  def create_user
    figo_connection.create_user(email: username, password: password, language: 'en', full_name: 'Ruby Test')
  end

  def destroy_user
    figo_session.remove_user
  end
end

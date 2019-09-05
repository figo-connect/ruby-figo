# frozen_string_literal: true

require 'flt'
require 'minitest/autorun'
require 'minitest/reporters'
require 'securerandom'

require_relative '../lib/figo'

module Setup
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

  def setup
    @username ||= "#{SecureRandom.alphanumeric(8)}@test.com"
    @password ||= 'password'
    @client_id ||= 'CaESKmC8MAhNpDe5rvmWnSkRE_7pkkVIIgMwclgzGcQY'
    @client_secret ||= 'STdzfv0GXtEj_bwYn7AgCVszN1kKq5BdgEIKOM_fzybQ'
  end

  private

  attr_reader :username, :password, :client_id, :client_secret

  def access_token(scope)
    response = figo_connection.user_credential_request(username, password, scope)
    response['access_token']
  end

  def figo_session(scope = 'accounts=rw balance=rw create_user offline securities=rw transactions=rw user=rw')
    token = access_token(scope)
    @figo_session ||= Figo::Session.new(token)
  end

  def figo_connection
    @figo_connection ||= Figo::Connection.new(client_id, client_secret)
  end

  def create_user
    figo_connection.create_user(username, password, 'Ruby Test', 'en')
  end

  def destroy_user
    figo_session.remove_user
  end
end

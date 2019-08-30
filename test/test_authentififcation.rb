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

require 'flt'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require_relative '../lib/figo'
require_relative 'setup'

class FigoTest < MiniTest::Unit::TestCase
  include Setup

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

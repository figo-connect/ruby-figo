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

require "flt"
require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require_relative "../lib/figo"

class FigoTest < MiniTest::Unit::TestCase
  def setup
    @sut = Figo::Session.new(CONFIG["ACCESS_TOKEN"])
    @con = Figo::Connection.new(CONFIG["CLIENT_ID"], CONFIG["CLIENT_SECRET"])
  end

  ##   User Management
  # Retrieve Current User
  def test_retreive_current_user
    assert @sut.user
  end

  # Create New Figo User
  def test_create_new_figo_user
    assert_raises(Figo::Error) { @con.create_user("John Doe", "jd@example.io", "123456", "en") }
  end

  # Re-Send Verification Email
  def test_resend_verififcation_email
    assert_nil @sut.resend_verification
  end

  # Modify Current User
  def test_modify_current_user
    old_user = @sut.user
    new_user_hash = {
      address: {
          city: "Hamburg",
          company: "blablabla",
          postal_code: "10969",
          street: "Ritterstr. 2-3"
      },
      email: "demo@figo.me",
      join_date: "2012-04-19T17:25:54.000Z",
      language: "en",
      name: "ola ola",
      premium: true,
      premium_expires_on: "2014-04-19T17:25:54.000Z",
      premium_subscription: "paymill",
      send_newsletter: true,
      user_id: "U12345",
      verified_email: true
    }
    new_user = Figo::User.new(@sut, new_user_hash)
    execption = assert_raises(Figo::Error) { @sut.modify_user(new_user) }
    assert "Missing, invalid or expired access token.", execption.message
    # api_user = @sut.modify_user(new_user)
    # assert_equal api_user.address["company"], "blablabla"
  end

  # Delete Current User
  def test_delete_current_user
    execption = assert_raises(Figo::Error) { @sut.remove_user }
    assert "Missing, invalid or expired access token.", execption.message
    # assert_nil @sut.remove_user
  end
end

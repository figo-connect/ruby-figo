# frozen_string_literal: true

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

  # Retrieve Securities of all Accounts
  def test_retreive_securities_of_all_accounts
    assert figo_session.get_securities({})
  end

  # Retrieve Securities of one Account
  def test_retreive_securities_of_one_account
    assert figo_session.get_securities(account_id: 'A1.4')
  end

  # Test works but endpoint not present anymore in the API
  # # Modify a Security
  # def test_modify_a_security
  #   exception = assert_raises(Figo::Error) { figo_session.modify_security("A1.4", "S1.1", true) }
  #   assert "Missing, invalid or expired access token.", exception.message
  # end

  # Test works but endpoint not present anymore in the API
  # # Modify all Securities of all Accounts
  # def test_modify_all_securities_of_all_accounts
  #   exception = assert_raises(Figo::Error) { figo_session.modify_securities(true) }
  #   assert "Missing, invalid or expired access token.", exception.message
  # end

  # Test works but endpoint not present anymore in the API
  # # Modify all Securities of one Account
  # def test_modify_all_securities_of_one_accounts
  #   exception = assert_raises(Figo::Error) { figo_session.modify_securities(true, "A1.4") }
  #   assert "Missing, invalid or expired access token.", exception.message
  # end
end

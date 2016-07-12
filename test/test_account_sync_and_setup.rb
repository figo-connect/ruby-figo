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
  end

  ##   Account Setup & Synchronization
  # Retrieve List of Supported Banks, Credit Cards, other Payment Services
  def test_retrieve_list_of_supported_baks_cards_services
    execption = assert_raises(Figo::Error) { @sut.get_supported_payment_services("DE", "whatever") }
    assert "Missing, invalid or expired access token.", execption.message
    # assert @sut.get_supported_payment_services("DE", "whatever")
  end

  # Retrieve List of Supported Credit Cards and other Payment Services
  def test_retrieve_list_of_supported_cards_services
    execption = assert_raises(Figo::Error) { @sut.get_supported_payment_services("DE", "services") }
    assert "Missing, invalid or expired access token.", execption.message
    # assert @sut.get_supported_payment_services("DE", "services")
  end

  # Retrieve List of all Supported Banks
  def test_retreive_list_of_all_supported_banks
    execption = assert_raises(Figo::Error) { @sut.get_supported_payment_services("DE", "banks") }
    assert "Missing, invalid or expired access token.", execption.message
    # assert @sut.get_supported_payment_services("DE", "banks")
  end

  # Retrieve Login Settings for a Bank or Service
  def test_retreive_login_settings_for_a_bank_or_service
    execption = assert_raises(Figo::Error) { @sut.find_bank("B1.1") }
    assert "Missing, invalid or expired access token.", execption.message
    # assert @sut.find_bank("B1.1")
  end

  # Setup New Bank Account
  def test_setup_new_bank_account
    assert @sut.get_bank("B1.1")
  end
end

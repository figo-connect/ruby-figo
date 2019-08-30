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

  ## Transactions
  # Retrieve a Transaction
  def test_retreive_a_transaction
    transactions = figo_session.get_account('A1.2').transactions
    transaction = figo_session.get_transaction('A1.2', transactions[0].transaction_id)

    assert transaction
  end

  # Retrieve Transactions of one Account
  def test_retreive_transactions_of_one_account
    transactions = figo_session.get_account('A1.2').transactions
    assert !transactions.empty?
  end

  # Retrieve Transactions of all Accounts
  def test_retreive_transactions_of_all_accounts
    transactions = figo_session.transactions
    assert !transactions.empty?
  end

  # Modify a Transaction*
  def test_modify_a_transaction
    tID = @sut.get_account('A1.2').transactions[-1].transaction_id
    exception = assert_raises(Figo::Error) { figo_session.modify_transaction('A1.2', tID, true) }
    assert 'Missing, invalid or expired access token.', exception.message
  end

  # Modify all Transactions of one Account*
  def test_modify_all_transactions_of_one_account
    exception = assert_raises(Figo::Error) { figo_session.modify_transactions(false, 'A1.2') }
    assert 'Missing, invalid or expired access token.', exception.message
  end

  # Modify all Transactions of all Accounts*
  def test_modify_all_transactions_of_all_accounts
    exception = assert_raises(Figo::Error) { figo_session.modify_transactions(false) }
    assert 'Missing, invalid or expired access token.', exception.message
  end

  # Delete a Transaction
  def test_delete_transaction
    tID = figo_session.get_account('A1.2').transactions[-1].transaction_id
    exception = assert_raises(Figo::Error) { figo_session.modify_transactions('A1.2', tID) }
    assert 'Missing, invalid or expired access token.', exception.message
  end
end

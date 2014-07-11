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
require_relative "../lib/figo"


class FigoTest < MiniTest::Unit::TestCase

  def setup
    @sut = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")
  end

  def test_accounts
    @sut.accounts
    @sut.get_account "A1.1"
    account = @sut.get_account "A1.2"
    assert_equal account.account_id, "A1.2"

    # account sub-resources
    assert @sut.get_account("A1.2").balance.balance
    assert @sut.get_account("A1.2").balance.balance_date

    transactions = @sut.get_account("A1.2").transactions
    assert transactions.length > 0

    payments  = @sut.get_account("A1.2").payments
    assert payments.length >= 0
  end

  def test_global_transactions
    transactions = @sut.transactions
    assert transactions.length > 0
  end

  def test_global_payments
    payments = @sut.payments
    assert payments.length >= 0
  end

  def test_notifications
    notifications = @sut.notifications
    assert notifications.length >= 0
  end

  def test_missing_handling
    assert_nil @sut.get_account "A1.42"
  end

  def test_error_handling
    assert_raises(Figo::Error) { @sut.sync_url "http://localhost:3003/", "" }
  end

  def test_sync_uri
    @sut.sync_url("qwe", "qew")
  end

  def test_user
    @sut.user
  end

  def test_create_update_delete_notification
    added_notification = @sut.add_notification(Figo::Notification.new(@sut, {:observe_key => "/rest/transactions", :notify_uri => "http://figo.me/test", :state => "qwe"}))
    refute_nil added_notification.notification_id
    assert_equal added_notification.observe_key, "/rest/transactions"
    assert_equal added_notification.notify_uri, "http://figo.me/test"
    assert_equal added_notification.state, "qwe"

    added_notification.state = "asd"
    modified_notification = @sut.modify_notification(added_notification)
    assert_equal modified_notification.notification_id, added_notification.notification_id
    assert_equal modified_notification.observe_key, "/rest/transactions"
    assert_equal modified_notification.notify_uri, "http://figo.me/test"
    assert_equal modified_notification.state, "asd"

    retrieved_notification = @sut.get_notification(modified_notification.notification_id)
    assert_equal retrieved_notification.notification_id, added_notification.notification_id
    assert_equal retrieved_notification.observe_key, "/rest/transactions"
    assert_equal retrieved_notification.notify_uri, "http://figo.me/test"
    assert_equal retrieved_notification.state, "asd"

    @sut.remove_notification(retrieved_notification)
    assert_nil @sut.get_notification(added_notification.notification_id)
  end

  def test_create_update_delete_payment
    added_payment = @sut.add_payment(Figo::Payment.new(@sut, {:account_id => "A1.1", :type => "Transfer", :account_number => "4711951501", :bank_code => "90090042", :name => "figo", :purpose => "Thanks for all the fish.", :amount => 0.89}))
    refute_nil added_payment.payment_id
    assert_equal added_payment.account_id, "A1.1"
    assert_equal added_payment.bank_name, "Demobank"
    assert_equal added_payment.amount, 0.89

    added_payment.amount = 2.39
    modified_payment = @sut.modify_payment(added_payment)
    assert_equal modified_payment.payment_id, added_payment.payment_id
    assert_equal modified_payment.account_id, "A1.1"
    assert_equal modified_payment.bank_name, "Demobank"
    assert_equal modified_payment.amount, 2.39

    retrieved_payment = @sut.get_payment(modified_payment.account_id, modified_payment.payment_id)
    assert_equal retrieved_payment.payment_id, added_payment.payment_id
    assert_equal retrieved_payment.account_id, "A1.1"
    assert_equal retrieved_payment.bank_name, "Demobank"
    assert_equal retrieved_payment.amount, 2.39

    @sut.remove_payment(retrieved_payment)
    assert_nil @sut.get_payment(modified_payment.account_id, modified_payment.payment_id)
  end
end

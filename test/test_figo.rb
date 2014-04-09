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

require "test/unit"
require_relative "../lib/figo"


class FigoTest < Test::Unit::TestCase

  def test_accounts
    sut = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")

    sut.accounts
    sut.get_account "A1.1"
    account = sut.get_account "A1.2"
    assert_equal account.account_id, "A1.2"

    # account sub-resources
    balance = sut.get_account("A1.2").balance
    assert balance.balance
    assert balance.balance_date

    transactions = sut.get_account("A1.2").transactions
    assert transactions.length > 0
  end

  def test_global_transactions
    sut = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")
    transactions = sut.transactions
    self.assert transactions.length > 0
  end

  def test_sync_uri
    sut = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")
    sut.sync_url("qwe", "qew")
  end

  def test_create_update_delete_notification
    sut = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")

    notification = sut.add_notification(observe_key="/rest/transactions", notify_uri="http://figo.me/test", state="qwe")
    assert_equal notification.observe_key, "/rest/transactions"
    assert_equal notification.notify_uri, "http://figo.me/test"
    assert_equal notification.state, "qwe"

    notification.state = "asd"
    sut.modify_notification(notification)
        
    notification = sut.get_notification(notification.notification_id)
    assert_equal notification.observe_key, "/rest/transactions"
    assert_equal notification.notify_uri, "http://figo.me/test"
    assert_equal notification.state, "asd"

    sut.remove_notification(notification)
    assert_equal sut.get_notification(notification.notification_id), nil
  end
end

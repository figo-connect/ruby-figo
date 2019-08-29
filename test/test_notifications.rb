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
require_relative 'setup'

class FigoTest < MiniTest::Unit::TestCase
  include Setup

  ##  Notifications & Web Hooks
  # Retrieve all Notifications
  def test_retrieve_all_notifications
    notifications = figo_session.notifications
    assert notifications.length >= 0
  end

  # Create a New Notification
  def test_create_new_notification
    added_notification = figo_session.add_notification(Figo::Notification.new(figo_session, {:observe_key => "/rest/transactions", :notify_uri => "http://figo.me/test", :state => "qwe"}))

    refute_nil added_notification.notification_id
    assert_equal added_notification.observe_key, "/rest/transactions"
    assert_equal added_notification.notify_uri, "http://figo.me/test"
    assert_equal added_notification.state, "qwe"
  end

  # Retrieve one Specific Notification
  def test_retrieve_one_specific_notification
    added_notification = figo_session.add_notification(Figo::Notification.new(figo_session, {:observe_key => "/rest/transactions", :notify_uri => "http://figo.me/test", :state => "qwe"}))

    retrieved_notification = figo_session.get_notification(added_notification.notification_id)

    assert_equal retrieved_notification.notification_id, added_notification.notification_id
    assert_equal retrieved_notification.observe_key, "/rest/transactions"
    assert_equal retrieved_notification.notify_uri, "http://figo.me/test"
    assert_equal retrieved_notification.state, "qwe"
  end

  # Modify Single Notification
  def test_modify_single_notification
    added_notification = figo_session.add_notification(Figo::Notification.new(figo_session, {:observe_key => "/rest/transactions", :notify_uri => "http://figo.me/test", :state => "qwe"}))

    added_notification.state = "asd"
    modified_notification = figo_session.modify_notification(added_notification)

    assert_equal modified_notification.notification_id, added_notification.notification_id
    assert_equal modified_notification.observe_key, "/rest/transactions"
    assert_equal modified_notification.notify_uri, "http://figo.me/test"
    assert_equal modified_notification.state, "asd"
  end

  # Delete Notification
  def test_delete_notification
    added_notification = figo_session.add_notification(Figo::Notification.new(figo_session, {:observe_key => "/rest/transactions", :notify_uri => "http://figo.me/test", :state => "qwe"}))

    figo_session.remove_notification(added_notification)
    assert_nil figo_session.get_notification(added_notification.notification_id)
  end
end

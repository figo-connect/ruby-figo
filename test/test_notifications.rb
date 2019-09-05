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

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  before { create_user }
  after { destroy_user }

  ##  Notifications & Web Hooks
  # Retrieve all Notifications
  def test_retrieve_all_notifications
    notifications = figo_session.notifications
    assert notifications.length >= 0
  end

  # Create a New Notification
  def test_create_new_notification
    refute_nil added_notification.notification_id
    assert_equal added_notification.observe_key, notification.observe_key
    assert_equal added_notification.notify_uri, notification.notify_uri
    assert_equal added_notification.state, notification.state
  end

  # Retrieve one Specific Notification
  def test_retrieve_one_specific_notification
    retrieved_notification = figo_session.get_notification(added_notification.notification_id)
    assert_equal retrieved_notification.notification_id, added_notification.notification_id
    assert_equal retrieved_notification.observe_key, notification.observe_key
    assert_equal retrieved_notification.notify_uri, notification.notify_uri
    assert_equal retrieved_notification.state, notification.state
  end

  # Modify Single Notification
  def test_modify_single_notification
    added_notification.state = 'asd'
    modified_notification = figo_session.modify_notification(added_notification)
    assert_equal modified_notification.state, 'asd'
  end

  # Delete Notification
  def test_delete_notification
    figo_session.remove_notification(added_notification)
    assert_nil figo_session.get_notification(added_notification.notification_id)
  end

  private

  def added_notification
    @added_notification ||= figo_session.add_notification(notification)
  end

  def notification
    @notification ||= Figo::Model::Notification.new(
      figo_session,
      observe_key: '/rest/transactions',
      notify_uri: 'http://figo.me/test',
      state: 'qwe'
    )
  end
end

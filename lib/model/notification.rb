# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    # Object representing a configured notification, e.g. a webhook or email hook
    class Notification < Base
      DUMP_ATTRIBUTES = %i[observe_key notify_uri state].freeze

      # Internal figo Connect notification ID from the notification registration response
      # @return [String]
      attr_accessor :notification_id

      # One of the notification keys specified in the figo Connect API specification
      # @return [String]
      attr_accessor :observe_key

      # Notification messages will be sent to this URL
      # @return [String]
      attr_accessor :notify_uri

      # State similiar to sync and logon process. It will passed as POST payload for webhooks
      # @return [String]
      attr_accessor :state
    end
  end
end
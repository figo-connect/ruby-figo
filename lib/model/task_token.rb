# frozen_string_literal: true
require_relative 'base'

module Figo
  module Model
    class TaskToken < Base
      DUMP_ATTRIBUTES = [:task_token]

      # Name of creditor or debtor
      # @param task_token [Hash] - Task ID
      attr_accessor :task_token
    end
  end
end

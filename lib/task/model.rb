# frozen_string_literal: true

require_relative '../base.rb'
module Figo
  class TaskToken < Base
    @dump_attributes = [:task_token]

    # Name of creditor or debtor
    # @param task_token [Hash] - Task ID
    attr_accessor :task_token
  end

  class TaskState < Base
    @dump_attributes = %i[account_id message is_waiting_for_pin is_waiting_for_response is_erroneous is_ended challenge]

    # @param account_id [String] - Account ID of currently processed accoount
    attr_accessor :account_id

    # @param message [String] - Status message or error message for currently processed amount
    attr_accessor :message

    # @param is_waiting_for_pin [Boolean] - The figo Connect server is waiting for PIN
    attr_accessor :is_waiting_for_pin

    # @param is_waiting_for_response [Boolean] - The figo Connect server is waiting for
    #                                            a response to the parameter challenge
    attr_accessor :is_waiting_for_response

    # @param is_erroneous [Boolean] - An error occured and the figo Connect server is waiting for continuation
    attr_accessor :is_erroneous

    # @param is_ended [Boolean] - The communication with a bank server has been completed
    attr_accessor :is_ended

    # @param challenge [Object] - A challenge object
    attr_accessor :challenge
  end
end

# frozen_string_literal: true

require_relative 'model.rb'
module Figo
  # Start communication with bank server.
  #
  # @param task_token [Object] Task token object from the initial request
  def start_task(task_token)
    query_api('/task/start?id=' + task_token.task_token, nil, 'GET')
  end

  # Poll the task progress.
  #
  # @param task [Object] - Task object
  # @param options [Object] - further options (optional)
  #    @param options.pin [Boolean] - submit PIN
  #    @param options.continue [Boolean] - this flag signals to continue after an error condition or
  #                                        to skip a PIN or challenge-response entry
  #    @param options.save_pin [Boolean] - this flag indicates whether the user has chosen to
  #                                        save the PIN on the figo Connect server
  #    @param options.response [Boolean] - submit response to challenge
  # @return [TaskState] The result parameter is a TaskState object which represents the current status of the task.
  def get_task_state(task, options)
    options ||= {}
    options['id'] = task['task_token']
    options.save_pin ||= 0 if options['pin']
    options.continue ||= 0

    query_api_object TaskState, '/task/progress?id=' + task.task_token, URI.encode_www_form(options), 'POST', nil
  end

  # Cancel a task.
  #
  # @param task_token [Object] Task token object
  def cancel_task(task_token)
    options['id'] = task_token['task_token']
    query_api_object TaskToken, '/task/cancel?id=' + task_token['task_token'], URI.encode_www_form(options), 'POST', nil
  end
end

require_relative "model.rb"
module Figo
  # Begin process.
  #
  # @param process [Hash] - Process token object
  def start_process(process)
    query_api "/process/start?id=" + process.process_token, nil, "GET"
  end

  # Create a process.
  #
  # @param proc [Hash] - Process object
  # @return [Hash] - The result parameter is a ProcessToken object of a newly created process.
  def create_process(proc)
    query_api_object ProcessToken, "/client/process", proc.dump(), "POST", nil
  end
end

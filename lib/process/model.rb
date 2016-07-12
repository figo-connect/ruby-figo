require_relative "../base.rb"
module Figo
  ### Object representing a process token
  class ProcessToken < Base
    @dump_attributes = [:process_token];
    def initialize(session, json)
      super(session, json)
    end

    # Properties:
    # @param process_token [Object] - Process ID
    attr_accessor :process_token
  end

  ### Object representing a Bsiness Process
  class Process < Base
    @dump_attributes = [:email, :password, :redirect_uri, :state, :steps]
    def initialize(session, json)
      super(session, json)
    end

    # Properties:
    # @param email [String] - The email of the existing user to use as context or the new user to create beforehand
    attr_accessor :email
    # @param password [String] - The password of the user existing or new user
    attr_accessor :password
    # @param redirect_uri [String] - The authorization code will be sent to this callback URL
    attr_accessor :redirect_uri
    # @param state [String] - Any kind of string that will be forwarded in the callback  response message
    attr_accessor :state
    # @param steps [String] - A list of steps definitions
    attr_accessor :steps
  end
end

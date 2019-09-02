# frozen_string_literal: true

require_relative '../base.rb'
module Figo
  # Object representing an User
  class User < Base
    @dump_attributes = %i[full_name email language password new_password]

    # Internal figo Connect User ID
    # @return [String]
    attr_accessor :id

    # First and last name
    # @return [String]
    attr_accessor :full_name

    # Email address
    # @return [String]
    attr_accessor :email

    # Email address
    # @return [String]
    attr_accessor :password

    # Email address
    # @return [String]
    attr_accessor :new_password

    # Two-letter code of preferred language
    # @return [String]
    attr_accessor :language

    # Timestamp of figo Account registration
    # @return [DateTime]
    attr_accessor :created_at
  end
end

require_relative "../base.rb"
module Figo
  # Object representing an User
  class User < Base
    @dump_attributes = [:name, :address, :send_newsletter, :language]

    def initialize(session, json)
      super(session, json)
    end

    # Internal figo Connect User ID
    # @return [String]
    attr_accessor :User_id

    # First and last name
    # @return [String]
    attr_accessor :name

    # Email address
    # @return [String]
    attr_accessor :email

    #Postal address for bills, etc.
    # @return [Dict]
    attr_accessor :address

    # This flag indicates whether the email address has been verified
    # @return [Boolean]
    attr_accessor :verified_email

    # This flag indicates whether the User has agreed to be contacted by email
    # @return [Boolean]
    attr_accessor :send_newsletter

    # Two-letter code of preferred language
    # @return [String]
    attr_accessor :language

    # This flag indicates whether the figo Account plan is free or premium
    # @return [Boolean]
    attr_accessor :premium

    # Timestamp of premium figo Account expiry
    # @return [DateTime]
    attr_accessor :premium_expires_on

    # Provider for premium subscription or nil of no subscription is active
    # @return [String]
    attr_accessor :premium_subscription

    # Timestamp of figo Account registration
    # @return [DateTime]
    attr_accessor :join_date
  end
end

# frozen_string_literal: true

module Figo
  class AccessMethod
    def initialize(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end unless hash.nil? || hash.empty?
    end

    # @return [String] figo ID of the provider access method.
    attr_accessor :id

    # @return [String] Indicates whether payment accounts
    #                  falling into the scope of the PSD2 are accessed via this method.
    attr_accessor :in_psd2_scope

    # @return [String] Enum: "API" "FINTS" "SCRAPING"
    attr_accessor :type

    # @return [Array] array of strings
    #                 Enum: "Giro account" "Savings account" "Daily savings account"
    #                       "Credit card" "Loan account" "PayPal" "Depot" "Unknown"
    attr_accessor :supported_account_types

    # @return [Boolean] Indicates whether consent configuration may be provided
    attr_accessor :configurable_consent

    # @return [Boolean] Indicates whether account identifiers have to be provided to connect this financial source.
    attr_accessor :requires_account_identifiers

    # @return [Array] array of strings Enum: "EMBEDDED_1FA" "EMBEDDED_2FA" "REDIRECT" "DECOUPLED"
    attr_accessor :customer_authentication_flows

    # @return [String] Any advice useful to instruct the user on what data to provide.
    attr_accessor :advice

    # @return [Object]
    attr_accessor :credentials
  end
end
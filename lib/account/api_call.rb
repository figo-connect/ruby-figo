# frozen_string_literal: true
require_relative '../model/account'
require_relative '../model/account_balance'

module Figo
  # Retrieve all accounts
  #
  # @return [Array] an array of `Account` objects, one for each account the user has granted the app access
  def list_accounts
    query_api_object Model::Account, '/rest/accounts', nil, 'GET', 'accounts'
  end

  # Retrieve specific account.
  #
  # @param account_id [String] ID of the account to be retrieved.
  # @return [Account] account object
  def get_account(account_id, cents = false)
    query_api_object Model::Account, "/rest/accounts/#{account_id}?cents=#{cents}"
  end

  # Remove specific account
  #
  # @param account_id [String] the ID of thr account to remove
  def delete_account(account_id)
    account_id = account.is_a?(String) ? account : account.account_id
    query_api "/rest/accounts/#{account_id}", nil, 'DELETE'
  end

  # @param cents [Boolean] If true amounts will be shown in cents.
  # @return [AccountBalance] account balance object
  def get_account_balance(account_id, cents = false)
    query_api_object Model::AccountBalance, "/rest/accounts/#{account_id}/balance?cents=#{cents}"
  end

  # Retrieve balance of an account.
  # TODO: OUT OLD IMPLEMENTATION - CHECK DIFFS
  #
  # # @param accounts [Array] List of JSON objects with the field account_id set to the internal figo Connect account ID (the accounts will be sorted in the list order)
  # def account_sort_order (accounts)
  #   query_api "/rest/accounts", accounts, "PUT"
  # end

  # # Add new bank account_sort_order
  # #
  # # @param country_code [String] Two-letter country code
  # # @param credentials [Array] List of login credential strings
  # # @param bank_code [String] Bank code (will be overriden if IBAN is present)
  # # @param iban [String] IBAN
  # # @param save_pin [Boolean] This flag indicates whether the user has chosen to save the PIN on the figo Connect server
  # # @param disable_first_sync [Boolean] This flag indicates whether we want to sync account transactions when connecting to it
  # def add_account(country, credentials, bank_code, iban, save_pin, disable_first_sync = false)
  #   data = {"country" => country, "credentials" => credentials}
  #   data["iban"] = iban if (iban)
  #   data["bank_code"] = bank_code if(bank_code)
  #   data["save_pin"] = !!save_pin == save_pin ? save_pin : false
  #   data["disable_first_sync"] = disable_first_sync

  #   query_api_object TaskToken, "/rest/accounts", data, "POST"
  # end
end

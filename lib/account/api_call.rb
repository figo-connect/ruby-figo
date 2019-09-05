# frozen_string_literal: true

require_relative 'model.rb'
require_relative '../account_balance/model'
module Figo
  # Retrieve all accounts
  #
  # @return [Array] an array of `Account` objects, one for each account the user has granted the app access
  def list_accounts
    query_api_object Account, '/rest/accounts', nil, 'GET', 'accounts'
  end

  # Retrieve specific account.
  #
  # @param account_id [String] ID of the account to be retrieved.
  # @return [Account] account object
  def get_account(account_id, cents = false)
    query_api_object Account, "/rest/accounts/#{account_id}?cents=#{cents}"
  end

  # Remove specific account
  #
  # @param account_id [String] the ID of thr account to remove
  def delete_account(account_id)
    account_id = account.is_a?(String) ? account : account.account_id
    query_api "/rest/accounts/#{account_id}", nil, 'DELETE'
  end

  # Retrieve balance of an account.
  #
  # @param cents [Boolean] If true amounts will be shown in cents.
  # @return [AccountBalance] account balance object
  def get_account_balance(account_id, cents = false)
    query_api_object AccountBalance, "/rest/accounts/#{account_id}/balance?cents=#{cents}"
  end
end

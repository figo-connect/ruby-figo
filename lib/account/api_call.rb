require_relative "model.rb"
module Figo
  # Retrieve all accounts
  #
  # @return [Array] an array of `Account` objects, one for each account the user has granted the app access
  def accounts
    query_api_object Account, "/rest/accounts", nil, "GET", "accounts"
  end

  # Retrieve specific account.
  #
  # @param account_id [String] ID of the account to be retrieved.
  # @return [Account] account object
  def get_account(account_id, cents=false)
    query_api_object Account, "/rest/accounts/#{account_id}?cents=#{cents}"
  end

  # Remove specific account
  #
  # @param account [Account, String] the account to be removed or its ID
  def remove_account(account)
    query_api account.is_a?(String) ? "/rest/accounts/#{account}" : "/rest/accounts/#{account.account_id}", nil, "DELETE"
  end

  # # Set bank account sort order
  # #
  # # @param accounts [Array] List of JSON objects with the field account_id set to the internal figo Connect account ID (the accounts will be sorted in the list order)
  # def account_sort_order (accounts)
  #   query_api "/rest/accounts", accounts, "PUT"
  # end
end

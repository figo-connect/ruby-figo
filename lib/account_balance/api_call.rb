require_relative "model.rb"
module Figo
  # Retrieve balance of an account.
  #
  # @return [AccountBalance] account balance object
  def get_account_balance(account_id)
    query_api_object AccountBalance, "/rest/accounts/#{account_id}/balance"
  end

  # Modify balance or account limits
  #
  # @param account_id [String] ID of the account which balance should be modified
  # @param account_balance [AccountBalance] modified AccountBalance to be saved
  # @return [AccountBalance] modified AccountBalance returned by server
  def modify_account_balance(account_id, account_balance)
    query_api_object AccountBalance, "/rest/accounts/#{account_id}/balance", account_balance.dump(), "PUT"
  end
end

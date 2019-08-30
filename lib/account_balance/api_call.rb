require_relative "model.rb"
module Figo
  # Retrieve balance of an account.
  #
  # @param cents [Boolean] If true amounts will be shown in cents.
  # @return [AccountBalance] account balance object
  def get_account_balance(account_id, cents=false)
    query_api_object AccountBalance, "/rest/accounts/#{account_id}/balance?cents=#{cents}"
  end
end

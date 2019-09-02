# frozen_string_literal: true

require_relative 'model.rb'
module Figo
  # Retrieve list of transactions (on all accounts)
  #
  # @return [Array] an array of `Transaction` objects, one for each transaction of the user
  def list_transactions(options)
    path =  "/rest/transactions?#{encodeOptions options}"
    query_api_object Transaction, path, nil, "GET", "transactions"
  end

  # Retrieve list of transactions (on a specific account)
  #
  # @param account_id [String] ID of the account for which to list the transactions
  # @return [Array] an array of `Transaction` objects, one for each transaction of the user
  def list_transactions_of_account(account_id, options)
    path = "/rest/accounts/#{account_id}/transactions?#{encodeOptions options}"
    query_api_object Transaction, path, nil, "GET", "transactions"
  end

  # Retrieve a specific transaction
  #
  # @param account_id [String] ID of the account on which the transaction occured (required)
  # @param transaction_id [String] ID of the transaction to be retrieved (optional)
  # @param cents [Boolean] If true amounts will be shown in cents (optional, default: false)
  # @return [Transaction] transaction object
  def get_transaction(account_id, transaction_id, cents = false)
    if transaction_id.nil?
      query_api_object Transaction, "/rest/accounts/#{account_id}/transactions?cents=#{cents}"
    else
      query_api_object Transaction, "/rest/accounts/#{account_id}/transactions/#{transaction_id}?cents=#{cents}"
    end
  end
end

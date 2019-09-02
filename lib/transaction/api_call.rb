# frozen_string_literal: true

require_relative 'model.rb'
module Figo
  # Retrieve list of transactions (on all or a specific account)
  #
  # @param account_id [String] ID of the account for which to list the transactions
  # @param since [String, Date] this parameter can either be a transaction ID or a date
  # @param count [Integer] limit the number of returned transactions
  # @param offset [Integer] which offset into the result set should be used to determin the first transaction to return (useful in combination with count)
  # @param include_pending [Boolean] this flag indicates whether pending transactions should be included
  #        in the response; pending transactions are always included as a complete set, regardless of
  #        the `since` parameter
  # @return [Array] an array of `Transaction` objects, one for each transaction of the user
  def transactions(account_id = nil, since = nil, count = 1000, offset = 0, include_pending = false)
    data = { 'count' => count.to_s, 'offset' => offset.to_s, 'include_pending' => include_pending ? '1' : '0' }
    data['since'] = ((since.is_a?(Date) ? since.to_s : since) unless since.nil?)

    query_api_object Transaction, (account_id.nil? ? '/rest/transactions?' : "/rest/accounts/#{account_id}/transactions?") + URI.encode_www_form(data), nil, 'GET', 'transactions'
  end

  # Retrieve a specific transaction
  #
  # @param account_id [String] ID of the account on which the transaction occured
  # @param transaction_id [String] ID of the transaction to be retrieved
  # @return [Transaction] transaction object
  def get_transaction(account_id, transaction_id)
    query_api_object Transaction, "/rest/accounts/#{account_id}/transactions/#{transaction_id}"
  end

  # Modify trasnaction
  #
  # @param account_id [String] ID of an account the transaction belongs to
  # @param transaction_id [String] ID of the transaction
  # @param visited [Boolean]  a bit showing whether the user has already seen this transaction or not
  def modify_transaction(account_id, transaction_id, visited)
    query_api_object Transaction, '/rest/accounts/' + account_id + '/transactions/' + transaction_id, { 'visited' => visited }, 'PUT'
  end

  # Modify transactions
  #
  # @param visited [Boolean] a bit showing whether the user has already seen this transaction or not
  # @param account_id [String] ID of the account transactions belongs to (optional)
  def modify_transactions(visited, account_id = nil)
    if account_id
      query_api '/rest/accounts/' + account_id + '/transactions', { 'visited' => visited }, 'PUT'
    else
      query_api '/rest/transactions', { 'visited' => visited }, 'PUT'
    end
  end

  # Delete transaction
  #
  # @param account_id [String] ID of an account the transaction belongs to
  # @param transaction_id [String] ID of transaction to be deleted
  def delete_transaction(account_id, transaction_id)
    query_api '/rest/accounts/' + account_id + '/transactions/' + transaction_id, nil, 'DELETE'
  end
end

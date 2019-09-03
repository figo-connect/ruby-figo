# frozen_string_literal: true

require_relative 'model.rb'
module Figo
  # Retrieve list of transactions (on all accounts)
  #
  # @param options [Object]: further optional options
  #           accounts: comma separated list of account IDs.
  #           filter (obj) - Can take 4 possible keys:
  #               - date (ISO date) - Transaction date
  #               - person (str) - Payer or payee name
  #               - purpose (str)
  #               - amount (num)
  #           sync_id (str): Show only those items that have been created within this synchronization.
  #           count (int): Limit the number of returned transactions.
  #           offset (int): Which offset into the result set should be used to determine the
  #                       first transaction to return (useful in combination with count)
  #           sort (enum): ASC or DESC
  #           since (ISO date): Return only transactions after this date based on since_type
  #           until (ISO date): This parameter can either be a transaction ID or a date. Return only transactions which were booked on or before
  #           since_type (enum): This parameter defines how the parameter since will be interpreted.
  #                               Possible values: "booked" "created" "modified"
  #           types (enum): Comma separated list of transaction types used for filtering.
  #                         Possible values:"Transfer", "Standing order", "Direct debit", "Salary or rent", "GeldKarte", "Charges or interest"
  #           cents (bool): If true amounts will be shown in cents, Optional, default: False
  #           include_pending (bool): This flag indicates whether pending transactions should
  #                                 be included in the response. Pending transactions are always
  #                                 included as a complete set, regardless of the `since` parameter.
  #           include_statistics (bool): Includes statistics on the returned transactionsif true, Default: false.
=======
  # @param account_id [String] ID of the account for which to list the transactions
  # @param since [String, Date] this parameter can either be a transaction ID or a date
  # @param count [Integer] limit the number of returned transactions
  # @param offset [Integer] which offset into the result set should be used to determin the first
  #                         transaction to return (useful in combination with count)
  # @param include_pending [Boolean] this flag indicates whether pending transactions should be included
  #        in the response; pending transactions are always included as a complete set, regardless of
  #        the `since` parameter
  # @return [Array] an array of `Transaction` objects, one for each transaction of the user
  def list_transactions(options)
    path =  "/rest/transactions?#{encodeOptions options}"
    query_api_object Transaction, path, nil, "GET", "transactions"
  end

  # Retrieve list of transactions (on a specific account)
  #
  # @param account_id [String] ID of the account for which to list the transactions
  # @param options [Object]: further optional options
  #           accounts: comma separated list of account IDs.
  #           filter (obj) - Can take 4 possible keys:
  #               - date (ISO date) - Transaction date
  #               - person (str) - Payer or payee name
  #               - purpose (str)
  #               - amount (num)
  #           count (int): Limit the number of returned transactions.
  #           offset (int): Which offset into the result set should be used to determine the
  #                       first transaction to return (useful in combination with count)
  #           sort (enum): ASC or DESC
  #           since (ISO date): Return only transactions after this date based on since_type
  #           until (ISO date): This parameter can either be a transaction ID or a date. Return only transactions which were booked on or before
  #           since_type (enum): This parameter defines how the parameter since will be interpreted.
  #                               Possible values: "booked" "created" "modified"
  #           types (enum): Comma separated list of transaction types used for filtering.
  #                         Possible values:"Transfer", "Standing order", "Direct debit", "Salary or rent", "GeldKarte", "Charges or interest"
  #           cents (bool): If true amounts will be shown in cents, Optional, default: False
  #           include_pending (bool): This flag indicates whether pending transactions should
  #                                 be included in the response. Pending transactions are always
  #                                 included as a complete set, regardless of the `since` parameter.
  #           include_statistics (bool): Includes statistics on the returned transactionsif true, Default: false.
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

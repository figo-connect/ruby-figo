# frozen_string_literal: true
require_relative '../model/payment'

module Figo
  # Retrieve list of all payments (on all accounts or one)
  #
  # @param account_id [String] ID of the account for whicht to list the payments
  # @param accounts [String] Comma separated list of account IDs to filter the payments
  # @param count [Integer] Limit the number of returned items, Optional, default: 1000
  # @param offset [Integer] Skip this number of transactions, Optional, default: 0
  # @param cents [Boolean] If true amounts will be shown in cents, Optional, default: false
  # @return [Payment] an array of `Payment` objects, one for each payment
  def payments(account_id = nil, accounts = nil, count = 1000, offset = 0, cents = false)
    options = { accounts: accounts, count: count, offset: offset, cents: cents }.delete_if { |_k, v| v.nil? }.to_query
    path = if account_id.nil?
             "/rest/payments?#{options}"
           else
             "/rest/accounts/#{account_id}/payments?#{options}"
           end
    query_api_object Model::Payment, path, nil, 'GET', 'payments'
  end

  # Retrieve specific payment.
  #
  # @param account_id [String] ID for the account on which the payment to be retrieved was created, Required
  # @param payment_id [String] ID of the notification to be retrieved, Required
  # @param cents [Boolean] If true amounts will be shown in cents, Optional, default: false
  # @return [Payment] `Payment` object for the respective payment
  def get_payment(account_id, payment_id, cents = false)
    query_api_object Model::Payment, "/rest/accounts/#{account_id}/payments/#{payment_id}?cents=#{cents}"
  end

  # Create new payment
  #
  # @param account_id [String] ID of the account related to Payment object to be created.
  # @param payment [Payment] payment object to be created. It should not have a payment_id set, Required
  # @return [Payment] newly created `Payment` object
  def create_payment(account_id, data)
    query_api_object Model::Payment, "/rest/accounts/#{account_id}/payments", data, 'POST'
  end

  # Modify payment
  #
  # @param payment [Payment] modified payment object, required
  # @return [Payment] modified payment object
  def modify_payment(payment)
    query_api_object Model::Payment, "/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}", payment.to_hash, 'PUT'
  end

  # Initiate a payment
  #
  # @param payment [Payment] payment to be submitted
  # @param state [String] Any kind of string that will be forwarded in the callback response message, Required
  # @return [String] The result parameter is the URL to be opened by the user.

  def initiate_payment(payment, data)
    params = data.delete_if { |_k, v| v.nil? }
    query_api('/rest/accounts/' + payment.account_id + '/payments/' + payment.payment_id + '/init', params, 'POST')
  end

  # Get payment initation status
  #
  # @param payment [Payment] payment object
  # @param init_id [String] figo ID of the payment initation, Required
  # @return [Object] Initiation status of the payment
  def get_payment_initiation_status(payment, init_id)
    query_api("/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}/init/#{init_id}", nil, 'GET')
  end

  # Remove payment
  #
  # @param payment [Payment, String] payment object which should be removed
  def remove_payment(payment)
    query_api "/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}", nil, 'DELETE'
  end
end

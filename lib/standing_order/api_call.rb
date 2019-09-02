# frozen_string_literal: true

require_relative 'model.rb'
module Figo
  # Retreive a specific standing order.
  # @param standing_order_id [String] - ID of standing order to retreive
  # @param account_id [String] - ID of account, Optional
  # @param cents [Boolean] - whether to show the balance in cents (optional)
  # @return [StandingOrder] - a single `standing_order` hash.
  def get_standing_order(standing_order_id, account_id = nil, cents = false)
    path = if account_id.nil?
             "/rest/standing_orders/#{standing_order_id}?cents=#{cents}"
           else
             "/rest/accounts/#{account_id}/standing_orders/#{standing_order_id}?cents=#{cents}"
           end
    query_api_object StandingOrder, path, nil, 'GET', nil
  end

  # Get all standing orders.
  # @param cents [Boolean] - whether to show the balance in cents, Optional, default: false
  # @param account_id [String] - ID of account, Optional
  # @param accounts [Array] - ID of accounts to retreived the standing orders, Optional, (cannot be used with account_id)
  # @return [StandingOrder] a list of `standing_order` objects.
  def get_standing_orders(account_id = nil, cents = false, accounts = nil)
    if account_id.nil?
      options = { cents: cents, accounts: accounts }.delete_if { |_k, v| v.nil? }.to_query
      path =  "/rest/standing_orders?#{options}"
    else
      path = "/rest/accounts/#{account_id}/standing_orders?cents=#{cents}"
    end
    query_api_object StandingOrder, path, nil, 'GET', 'standing_orders'
  end

  # Mofify stading order of account
  # @param account_id [Boolean] - ID of account to standing order, Required
  # @return [StandingOrder] a list of `standing_order` objects.
  def get_account_standing_orders(standing_order, account_id = nil)
    query_api_object StandingOrder, "/rest/accounts/#{account_id}/standing_orders", standing_order.dump, 'PUT'
  end

  # Delete stading order
  # @param account_id [Boolean] - ID of account to standing order, Optional
  # @return [StandingOrder] a list of `standing_order` objects.
  def remove_standing_orders(account_id = nil)
    path = if account_id.nil?
             '/rest/standing_orders'
           else
             "/rest/accounts/#{account_id}/standing_orders"
           end
    query_api "/rest/accounts/#{account_id}/standing_orders", nil, 'DELETE'
  end
end

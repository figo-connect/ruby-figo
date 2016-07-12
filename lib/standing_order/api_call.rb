require_relative "model.rb"
module Figo
  # Retreive a specific standing order.
  # @param standing_order_id [String] - ID of standing order to retreive
  # @param cents [Boolean] - whether to show the balance in cents (optional)
  # @return [StandingOrder] - a single `standing_order` hash.
  def get_standing_order(standing_order_id)
    query_api_object StandingOrder, "/rest/standing_orders/" + standing_order_id, nil, "GET", nil
  end

  # Get all standing orders.
  # @param cents [Boolean] - whether to show the balance in cents (optional)
  # @return [StandingOrder] a list of `standing_order` objects.
  def get_standing_orders()
    query_api_object StandingOrder, "/rest/standing_orders", nil, "GET", "standing_orders"
  end

  # Get all standing orders.
  # @param account_id [Boolean] - ID of account to standing order
  # @return [StandingOrder] a list of `standing_order` objects.
  def get_account_standing_orders(account_id)
    query_api_object StandingOrder, "/rest/accounts/#{account_id}/standing_orders", nil, "GET", "standing_orders"
  end
end

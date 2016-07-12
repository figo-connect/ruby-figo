require_relative "model.rb"
module Figo
  # Retrieve list of all payments (on all accounts or one)
  #
  # @param account_id [String] ID of the account for whicht to list the payments
  # @return [Payment] an array of `Payment` objects, one for each payment
  def payments(account_id = nil)
    query_api_object Payment, account_id.nil? ? "/rest/payments" : "/rest/accounts/#{account_id}/payments", nil, "GET", "payments"
  end

  # Retrieve specific payment.
  #
  # @param account_id [String] ID for the account on which the payment to be retrieved was created
  # @param payment_id [String] ID of the notification to be retrieved
  # @return [Payment] `Payment` object for the respective payment
  def get_payment(account_id, payment_id)
    query_api_object Payment, "/rest/accounts/#{account_id}/payments/#{payment_id}"
  end

  # Create new payment
  #
  # @param payment [Payment] payment object to be created. It should not have a payment_id set.
  # @return [Payment] newly created `Payment` object
  def add_payment(payment)
    query_api_object Payment, "/rest/accounts/#{payment.account_id}/payments", payment.dump(), "POST"
  end

  # Modify payment
  #
  # @param payment [Payment] modified payment object
  # @return [Payment] modified payment object
  def modify_payment(payment)
    query_api_object Payment, "/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}", payment.dump(), "PUT"
  end

  # Submit payment to bank server
 #
  # @param payment [Payment] payment to be submitted
  # @param tan_scheme_id [String] TAN scheme ID of user-selected TAN scheme
  # @param state [String] Any kind of string that will be forwarded in the callback response message
  # @param redirect_uri [String] At the end of the submission process a response will be sent to this callback URL
  # @return [String] The result parameter is the URL to be opened by the user.
  def submit_payment (payment, tan_scheme_id, state, redirect_uri)
    params = {tan_scheme_id: tan_scheme_id, state: state}
    if(redirect_uri)
      params["redirect_uri"] = redirect_uri;
    end

    res = query_api("/rest/accounts/" + payment.account_id + "/payments/" + payment.payment_id + "/submit", params, "POST")

    if(res.task_token)
      "https://" + Config.api_endpoint + "/task/start?id=" + result.task_token
      callback(error);
    else
      res
    end
  end

  # Remove payment
  #
  # @param payment [Payment, String] payment object which should be removed
  def remove_payment(payment)
    query_api "/rest/accounts/#{payment.account_id}/payments/#{payment.payment_id}", nil, "DELETE"
  end

  # Retreive payment proposals
  #
  def get_payment_proposals
    query_api "/rest/address_book", nil, "GET"
  end
end

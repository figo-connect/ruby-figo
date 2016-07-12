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
  def get_account(account_id)
    query_api_object Account, "/rest/accounts/#{account_id}"
  end

  # Modify specific account
  #
  # @param account [Account] modified account to be saved
  # @return [Account] modified account returned by the server
  def modify_account(account)
    query_api_object Account, "/rest/accounts/#{account.account_id}", account.dump(), "PUT"
  end

  # Remove specific account
  #
  # @param account [Account, String] the account to be removed or its ID
  def remove_account(account)
    query_api account.is_a?(String) ? "/rest/accounts/#{account}" : "/rest/accounts/#{account.account_id}", nil, "DELETE"
  end

  # Set bank account sort order
  #
  # @param accounts [Array] List of JSON objects with the field account_id set to the internal figo Connect account ID (the accounts will be sorted in the list order)
  def account_sort_order (accounts)
    query_api "/rest/accounts", accounts, "PUT"
  end

  # Add new bank account_sort_order
  #
  # @param country_code [String] Two-letter country code
  # @param credentials [Array] List of login credential strings
  # @param bank_code [String] Bank code (will be overriden if IBAN is present)
  # @param iban [String] IBAN
  # @param save_pon [Boolean] This flag indicates whether the user has chosen to save the PIN on the figo Connect server
  def add_account(country, credentials, bank_code, iban, save_pin)
    data = {"country" => country, "credentials" => credentials}
    data["iban"] = iban if (iban)
    data["bank_code"] = bank_code if(bank_code)
    data["save_pin"] = !!save_pin == save_pin ? save_pin : false

    query_api_object TaskToken, "/rest/accounts", data, "POST"
  end
end

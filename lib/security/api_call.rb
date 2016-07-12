require_relative "model.rb"
require 'json'

module Figo
  # Retrieve a security.
  #
  # @param account_id [String] - ID of the account the security belongs to
  # @param security_id [String] - ID of the security to retrieve
  # @return [Security] - A single security object.
  def get_security(account_id, security_id)
    query_api_object Security, "/rest/accounts/" + account_id + "/securities/" + security_id, nil, "GET", nil
  end

  # Retrieve securities of one or all accounts.
  #
  # @param options [Object] - further options (all are optional)
  #   @param options.account_id [String] - ID of the account for which to retrieve the securities
  #   @param options.accounts [Array] - filter the securities to be only from these accounts
  #   @param options.since [Date] - ISO date filtering the returned securities by their creation or last modification date
  #   @param options.since_type [String] - defines hot the `since` will be interpreted: `traded`, `created` or `modified`
  #   @param options.count [Number] - limit the number of returned transactions
  #   @param options.offset [Number] - offset into the implicit list of transactions
  # @return [Security] - An array of `Security` objects.
  def get_securities(options = nil)
    options ||= {}
    options["count"] ||= 1000
    options["offset"] ||= 0
    if(!options["account_id"])
      query_api_object Security, "/rest/securities?" +  URI.encode_www_form(options), nil, "GET", 'securities'
    else
      account_id = options["account_id"]
      options.delete("account_id")
      query_api_object Security, "/rest/accounts/" + account_id + "/securities?" + URI.encode_www_form(options), nil, "GET", "securities"
    end
  end

  # Modify a security.
  # @param account_id [String] - ID of the account the security belongs to
  # @param security_id [String] - ID of the security to change
  # @param visited [Boolean] - a bit showing whether the user has already seen this security or not

  def modify_security (account_id, security_id, visited)
    data = {:visited => visited}
    query_api "/rest/accounts/" + account_id + "/securities/" + security_id, data, "PUT"
  end

  # Modify securities of one or all accounts.
  # @param visited [Boolean] - a bit showing whether the user has already seen these securities or not
  # @param account_id [String] - ID of the account securities belongs to (optional)

  def modify_securities (visited, account_id = nil)
    data = {visited: visited}
    if (account_id)
      query_api "/rest/accounts/" + account_id + "/securities", data, "PUT"
    else
      query_api "/rest/securities", data, "PUT"
    end
  end
end

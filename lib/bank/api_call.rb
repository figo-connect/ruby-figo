require_relative "model.rb"
module Figo
  # Retrieve specific bank
  #
  # @return [Bank] bank object
  def get_bank(bank_id)
    query_api_object Bank, "/rest/banks/#{bank_id}"
  end

  # Modify bank
  #
  # @param bank [Bank] modified bank object
  # @return [Bank] modified bank object returned by server
  def modify_bank(bank)
    query_api_object Bank, "/rest/banks/#{bank.bank_id}", bank.dump(), "PUT"
  end

  # Remove stored PIN from bank
  #
  # @param bank [Bank, String] the bank whose stored PIN should be removed or its ID
  # @return [nil]
  def remove_bank_pin(bank)
    query_api bank.is_a?(String) ? "/rest/banks/#{bank}/remove_pin" : "/rest/banks/#{bank.bank_id}/remove_pin", nil, "POST"
  end

  # Get bank information from standard bank code
  #
  # @param country_code [String]
  # @param bank_code [String] bank sort code (Bankleitzahl)
  # @return [Hash] JSON response
  def find_bank(bank_code, country_code = "DE")
    query_api "/rest/catalog/banks/#{country_code}/#{bank_code}"
  end

  # Get supported services
  #
  # @param country_code [String] the country code the service comes from
  # @param service [String] filter the type of service to request (optional): `banks`, `services` or everything (default)
  def get_supported_payment_services(country_code="DE", service)
    case service
    when "banks"
      query_api("/rest/catalog/banks/" + country_code, nil)
    when "service"
      query_api("/rest/catalog/services/" + country_code, nil)
    else
      query_api("/rest/catalog/" + country_code, nil)
    end
  end
end

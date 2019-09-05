# frozen_string_literal: true
require_relative '../model/catalog'

module Figo
  def self.included(klass)
    @prefix = '/rest' if klass.to_s == 'Session'
  end

  # List complete catalog (user auth or client auth.)
  # The real catalog contains thousands of entries, so expect the call to cause some traffic and delay.
  #
  # @param q [String] Two-letter country code. Show only resources within this country. Country code is case-insensitve.
  # @param country [String] Query for the entire catalog. Will match banks on domestic bank code, BIC, name or figo-ID.
  #        Will match services based on name or figo-ID. Only exact matches are returned.
  # @params objects [Enum] "banks" or "services", decide what is included in the api response.
  #         If not specified, it returns both
  # @return [Catalog] modified bank object returned by server
  def list_complete_catalog(q = nil, country = nil)
    options = { q: q, country: country }
    path = "#{@prefix}/catalog"
    query_api_object(Model::Catalog, parameterized_path(path, options), nil, 'GET')
  end

  def list_banks(q = nil, country = nil)
    options = { q: q, country: country }
    path = '/catalog/banks'
    query_api_object(Model::Bank, parameterized_path(path, options), nil, 'GET', 'banks')
  end

  def list_services(q = nil, country = nil)
    options = { q: q, country: country }
    path = '/catalog/services'
    query_api_object(Model::Service, parameterized_path(path, options), nil, 'GET', 'services')
  end
end

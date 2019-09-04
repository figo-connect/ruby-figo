# frozen_string_literal: true

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
  def list_complete_catalog(q: nil, country: nil, objects: nil)
    list_catalog(q, country, complete_path("#{@prefix}/catalog", objects))
  end

  private

  def list_catalog(q, country, path)
    options = { q: q, country: country }.delete_if { |_k, v| v.nil? }
    query_api_object Catalog, "#{path}?#{options.to_query}"
  end

  def complete_path(path, objects)
    %w[banks services].include?(objects) ? "#{path}/#{objects}" : path
  end
end

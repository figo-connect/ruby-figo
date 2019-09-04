# frozen_string_literal: true

require_relative '../access_method/model'
require_relative '../base'

module Figo
  class Bank < Base
    @dump_attributes = %i[
      id name icon supported country language
      access_methods bank_code bic
    ]

    def initialize(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
    end

    # @return [String] figo ID of financial service provider.
    attr_accessor :id

    # @return [String] Name of the financial service provider.
    attr_accessor :name

    # @return [Object]
    attr_accessor :icon

    # @return [Boolean] Indicates if access to financial source is supported by the figo API.
    attr_accessor :supported

    # @return [String] Country in which the financial service provider operates.
    attr_accessor :country 

    # @return [Object]
    attr_accessor :language

    # @return [Array] List of access methods available for this catalog item.
    attr_reader :access_methods
    def access_methods=(array)
      @access_methods = array.map { |hash| Figo::AccessMethod.new hash }
    end

    # @return [Object]
    attr_accessor :bank_code

    # @return [Object]
    attr_accessor :bic
  end
end

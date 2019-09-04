# frozen_string_literal: true

require_relative '../service/model'

module Figo
  class Bank < Service
    # @return [Object]
    attr_accessor :bank_code

    # @return [Object]
    attr_accessor :bic
  end
end

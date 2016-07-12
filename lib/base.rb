require "date"
require "flt"

module Figo
  # Set decimal precision to two digits.
  Flt::DecNum.context.precision = 2

  # Abstract base class for model objects.
  class Base
    # Attributes to be dumped (called by modify and create)
    @dump_attributes = []
    def self.dump_attributes
      @dump_attributes
    end

    # Instantiate model object from hash.
    #
    # @param session [Session] figo `Session` object
    # @param hash [Hash] use keys of this hash for model object creation
    def initialize(session, hash)
      @session = session

      hash.each do |key, value|
        key = key.to_s if key.is_a? Symbol
        next unless respond_to? "#{key}="
        next if value.nil?

        if key == "status" and value.is_a? Hash
          value = SynchronizationStatus.new(session, value)
        elsif key == "balance" and value.is_a? Hash
          value = AccountBalance.new(session, value)
        elsif key == "amount" or key == "balance" or key == "credit_line" or key == "monthly_spending_limit"
          value = Flt::DecNum(value.to_s)
        elsif key.end_with?("_date")
          value = DateTime.iso8601(value)
        elsif key.end_with?("_timestamp")
          value = DateTime.iso8601(value)
        end
        send("#{key}=", value)
      end
    end

    # Dump committable attributes to a hash
    def dump
      result = {}
      self.class.dump_attributes.each do |attribute|
        value = send attribute
        next if value.nil?
        value = value.to_f if value.is_a? Flt::DecNum

        result[attribute] = value
      end
      return result
    end
  end
end

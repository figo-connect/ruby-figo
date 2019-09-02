require_relative "../base.rb"
module Figo
  # Object representing a Catalog of Banks and Services
  class Catalog < Base
    @dump_attributes = %i[banks services]

    # List of banks
    # @return [Array]
    attr_accessor :banks

    # List of services
    # @return [Array]
    attr_accessor :services
  end
end

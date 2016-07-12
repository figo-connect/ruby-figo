module Figo
  # Base class for all errors transported via the figo Connect API.
  class Error < RuntimeError
    # Initialize error object.
    #
    # @param error [String] the error code
    # @param error_description [String] the error description
    def initialize(error, error_description)
      @error = error
      @error_description = error_description
    end

    # Convert error object to string.
    #
    # @return [String] the error description
    def to_s
      return @error_description
    end
  end
end

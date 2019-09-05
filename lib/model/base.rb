module Figo
  module Model
    class Base
      # Instantiate model object from hash.
      #
      # @param session [Session] figo `Session` object
      # @param hash [Hash] use keys of this hash for model object creation
      # @return [Object]
      def initialize(session, hash)
        @session = session
        from_hash(hash)
      end

      def from_hash(hash)
        unless hash.nil?
          hash.keys.each do |key|
            send("#{key}=", hash[key])
          end
        end
      end

      # Dump committable attributes to a hash
      # @return [Hash]
      def to_hash
        return if dump_attributes.empty?
        {}.tap do |hash|
          dump_attributes.each do |attribute|
            value = send(attribute)
            hash[attribute] = value if value
          end
        end
      end

      private

      def dump_attributes
        self.class::DUMP_ATTRIBUTES
      end
    end
  end
end
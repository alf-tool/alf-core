module Alf
  class Adapter
    class Connection

      ### connection, transaction, locks

      # Yields the block in a transaction
      def in_transaction(opts = {})
        yield
      end

      def closed?
        defined?(@closed) && @closed
      end

      # Closes the connection
      def close
        @closed = true
      end

      ### schema methods

      # Returns true if `name` is known, false otherwise.
      def knows?(name)
        false
      end

      # Returns the heading of a given named variable
      def heading(name)
        raise NotSupportedError, "Unable to serve heading of `#{name}` in `#{self}`"
      end

      # Returns the keys of a given named variable
      def keys(name)
        raise NotSupportedError, "Unable to serve keys of `#{name}` in `#{self}`"
      end

      ### read-only methods

      # Returns a cog for a given name
      def cog(name)
        raise NotSupportedError, "Unable to serve cog `#{name}` in `#{self}`"
      end

      ### update methods

      # Inserts `tuples` in the relvar called `name`
      def insert(name, tuples)
        raise NotSupportedError, "Unable to insert in `#{self}`"
      end

      # Delete from the relvar called `name`
      def delete(name, predicate)
        raise NotSupportedError, "Unable to delete in `#{self}`"
      end

      # Updates the relvar called `name`
      def update(name, computation, predicate)
        raise NotSupportedError, "Unable to update in `#{self}`"
      end

    end # class Connection
  end # class Adapter
end # module Alf

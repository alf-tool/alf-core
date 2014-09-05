module Alf
  class Adapter
    class Memory < Adapter

      # (see Connection.recognizes?)
      #
      # @return [Boolean] true if args contains one String only, which denotes
      #         an existing folder; false otherwise
      def self.recognizes?(conn_spec)
        conn_spec == 'memory://'
      end

      # Returns a connection on some memory relvars
      def connection
        Memory::Connection.new(conn_spec)
      end

      def to_s
        "Alf::Adapter::Memory(#{conn_spec})"
      end

      Adapter.register(:memory, self)
    end # class Memory
  end # class Adapter
end # module Alf
require_relative 'memory/connection'

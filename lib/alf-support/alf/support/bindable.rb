module Alf
  module Support
    module Bindable

      attr_accessor :connection
      protected :connection=

      def bind(connection)
        dup.tap{|c|
          c.connection = connection
          yield(c) if block_given?
        }
      end

      def bound?
        defined?(@connection) && !@connection.nil?
      end

      def connection!
        raise UnboundError, "Not bound `#{self}`" unless bound?
        @connection
      end

    end # module Bindable
  end # module Support
end # module Alf
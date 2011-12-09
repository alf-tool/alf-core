module Alf
  module Iterator
    module ClassMethods

      # Coerces something to an iterator
      def coerce(arg, environment = nil)
        case arg
        when Iterator, Array
          arg
        when String, Symbol
          Proxy.new(environment, arg.to_sym)
        else
          Reader.coerce(arg, environment)
        end
      end

    end # module ClassMethods
    extend(ClassMethods)
  end # module Iterator
end # module Alf

module Alf
  module Iterator
    module ClassMethods

      # 
      # Coerces something to an iterator
      #
      def coerce(arg, environment = nil)
        case arg
        when Iterator, Array
          arg
        else
          Reader.coerce(arg, environment)
        end
      end

    end # module ClassMethods
    extend(ClassMethods)
  end # module Iterator
end # module Alf

module Alf
  module Types
    #
    # Attribute name.
    #
    # Attribute names are ruby symbols that match the following regular 
    # expression:
    #
    #     /^[a-zA-Z0-9_]+$/
    #
    class AttrName < Symbol
      extend Myrrha::Domain

      class << self

        def predicate
          @predicate ||= lambda{|s| s.to_s =~ /^[a-zA-Z0-9_]+$/}
        end

        def coerce(arg)
          if arg.respond_to?(:to_sym)
            sym = arg.to_sym
            return sym if self.===(sym) 
          end
          raise ArgumentError, "Unable to coerce `#{arg.inspect}` to AttrName"
        end

        def from_argv(argv, opts = {})
          raise ArgumentError if argv.size > 1
          coerce(argv.first || opts[:default]) 
        end

      end

    end # class AttrName
  end # module Types
end # module Alf

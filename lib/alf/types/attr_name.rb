module Alf
  module Types
    #
    # Data type for being a valid attribute name
    #  
    class AttrName < Symbol
      extend Myrrha::Domain
      
      def self.predicate
        @predicate ||= lambda{|s| s.to_s =~ /^[a-zA-Z0-9_]+$/}
      end
            
      def self.coerce(arg)
        if arg.respond_to?(:to_sym)
          sym = arg.to_sym
          return sym if self.===(sym) 
        end
        raise ArgumentError, "Unable to coerce `#{arg.inspect}` to AttrName"
      end
      
      def self.from_argv(argv, opts = {})
        raise ArgumentError if argv.size > 1
        coerce(argv.first || opts[:default]) 
      end
      
    end # class AttrName
  end # module Types
end # module Alf

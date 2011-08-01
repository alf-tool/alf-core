module Alf
  module Operator
    #
    # Specialization of Operator for operators that are shortcuts for longer 
    # expressions.
    # 
    module Shortcut
      include Operator

      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        self.environment = env
        self.datasets = input
        self
      end

      protected 

      # (see Operator#_each)
      def _each
        longexpr.each(&Proc.new)
      end
      
      #
      # Compiles the longer expression and returns it.
      #
      # @return (Iterator) the compiled longer expression, typically another
      #         Operator instance
      #
      def longexpr
      end 
      undef :longexpr

      #
      # This is an helper ala Lispy#chain for implementing (#longexpr).
      #
      # @param [Array] elements a list of Iterator-able 
      # @return [Operator] the first element of the list, but piped with the 
      #         next one, and so on.
      #
      def chain(*elements)
        elements = elements.reverse
        elements[1..-1].inject(elements.first) do |c, elm|
          elm.pipe(c, environment)
          elm
        end
      end
      
    end # module Shortcut
  end # module Operator
end # module Alf

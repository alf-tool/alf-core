module Alf
  module Operator::NonRelational
    # 
    # Force attribute coercion according to a heading
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 DOM1 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Non strict mode
    #   (coerce :parts, :weight => Float, :color => Color)
    #
    # DESCRIPTION
    #
    # This operator coerce attributes of the input tuples according to the 
    # domain information provided by a heading, thats is a set of attribute 
    # (name,type) pairs.   
    #
    # When used in shell, the heading is built from commandline arguments ala 
    # Hash[...]. Foe example:
    #
    #   alf coerce parts -- weight Float color Color
    #
    class Coerce < Factory::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
    
      # Coerce heading
      attr_accessor :heading
      
      def initialize(heading = {})
        @heading = Heading.coerce(heading)
      end
      
      protected 
      
      # (see Operator::CommandMethods#set_args)
      def set_args(args)
        h = tuple_collect(args.each_slice(2)) do |k,v|
          [k.to_sym, Kernel.eval(v)]
        end
        @heading = Heading.new(h)
      end
      
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge tuple_collect(@heading.attributes){|k,d|
          [k, Myrrha.coerce(tuple[k], d)]
        }
      end
    
    end # class Coerce
  end # module Operator::NonRelational
end # module Alf
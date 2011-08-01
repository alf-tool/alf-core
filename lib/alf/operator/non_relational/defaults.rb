module Alf
  module Operator::NonRelational
    # 
    # Force default values on missing/nil attributes
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 EXPR1 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Non strict mode
    #   (defaults :suppliers, :country => 'Belgium')
    #
    #   # Strict mode (--strict)
    #   (defaults :suppliers, {:country => 'Belgium'}, true)
    #
    # DESCRIPTION
    #
    # This operator rewrites tuples so as to ensure that all values for specified 
    # attributes ATTRx are defined and not nil. Missing or nil attributes are 
    # replaced by the associated default value VALx. The latter can be either 
    # true values, or tuple expressions.
    #
    # When used in shell, all defaults values are interpreted as being tuple 
    # expressions. Consequently, strings should be quoted, as in the following
    # example:
    #
    #   alf defaults suppliers -- country "'Belgium'"
    #
    # When used in --strict mode, the operator simply project resulting tuples on
    # attributes for which a default value has been specified. Using the strict 
    # mode guarantess that the heading of all tuples is the same, and that no nil
    # value ever remains. However, this operator never remove duplicates. 
    #
    class Defaults < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
  
      signature [
        [:defaults, TupleComputation, {}]
      ]
      
      def initialize(defaults = {}, strict = false)
        @defaults = coerce(defaults, TupleComputation)
        @strict = strict
      end
      
      options do |opt|
        opt.on('-s', '--strict', 
               'Strictly restrict to default attributes') do
          @strict = true 
        end
      end
  
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        handle = TupleHandle.new.set(tuple)
        defs = @defaults.evaluate(handle)
        keys = @strict ? defs.keys : (tuple.keys | defs.keys)
        tuple_collect(keys){|k|
          [k, coalesce(tuple[k], defs[k])]
        }
      end
      
    end # class Defaults
  end # module Operator::NonRelational
end # module Alf

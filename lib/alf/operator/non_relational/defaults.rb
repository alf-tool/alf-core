module Alf
  module Operator::NonRelational
    # 
    # Force default values on missing/nil attributes
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    # This non-relational operator rewrites input tuples to ensure that all 
    # values for attribute names specified in DEFAULTS are present and not nil. 
    # Missing or nil attributes are replaced by the specified default value.
    #
    # A value specified in DEFAULTS may be any tuple expression. This allows to 
    # compute the default value as an expression on the current tuple.
    #
    # With --strict mode, the operator projects resulting tuples on attributes 
    # for which a default value has been specified. Using the strict mode 
    # guarantees that the heading of all tuples is the same, and that no nil 
    # value ever remains. 
    #
    # Note that this operator never removes duplicates. Even in --strict mode 
    # the result might be an invalid relation. 
    #
    # EXAMPLE
    #
    #   alf defaults suppliers -- country "'Belgium'"
    #   alf defaults --strict suppliers -- country "'Belgium'"
    #
    class Defaults < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
  
      signature do |s|
        s.argument :defaults, TupleComputation, {}
        s.option :strict, Boolean, false, "Restrict to default attributes only?"
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

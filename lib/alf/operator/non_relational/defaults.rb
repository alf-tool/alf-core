module Alf
  module Operator::NonRelational
    class Defaults < Alf::Operator()
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

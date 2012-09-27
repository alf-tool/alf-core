module Alf
  module Types
    #
    # Defines the computation of a tuple from expressions mapped to names.
    #
    # Example:
    #   computation = TupleComputation[
    #     :big? => lambda{ status > 20 }
    #     :who  => lambda{ "#{first} #{last}" }
    #   ]
    #   computation.call(:last => "Jones", :first => "Bill", :status => 10)
    #   # => {:big? => false, :who => "Bill Jones"}
    #
    class TupleComputation
      extend Domain::Scalar.new(:computation)

      coercions do |c|
        c.delegate :to_tuple_computation
        c.upon(Hash){|arg,_|
          TupleComputation.new Hash[arg.map{|k,v|
            if AttrName === k
              [ k, v.is_a?(Proc) ? TupleExpression.coerce(v) : v ]
            else
              [ AttrName.coerce(k), TupleExpression.coerce(v) ]
            end
          }]
        }
        c.upon(Array){|arg,_|
          coerce(Hash[*arg])
        }
      end

      class << self

        alias :[] :coerce

      end # class << self

      # Makes the computation in the context of a tuple
      #
      # This is a convenient method for the following, longer expression:
      #
      #     evaluate(TupleScope.new(tuple))
      #
      # Note, however, using a scope as in the example above is much more
      # efficient when evaluating the same computation on multiple tuples
      # in sequence.
      #
      # @param [Hash] tuple a Tuple instance
      # @return [Object] the resulting tuple
      def call(tuple)
        evaluate(Support::TupleScope.new(tuple))
      end
      alias :[] :call

      # Computes the resulting tuple when expressions are evaluated in the
      # context of `scope`
      #
      # @param [TupleScope] scope a tuple scope instance.
      # @return [Hash] the resulting tuple
      def evaluate(scope = nil)
        Hash[ @computation.map{|k,v|
          [k, v.is_a?(TupleExpression) ? v.evaluate(scope) : v]
        }]
      end

      # Returns self
      def to_tuple_computation
        self
      end

      # Converts to a heading.
      #
      # @return [AttrList] a computed heading from static analysis of expressions
      def to_heading
        Heading.new Hash[computation.map{|name,expr|
          [name, expr.is_a?(TupleExpression) ? expr.infer_type : expr.class]
        }]
      end

      # Converts to an attribute list.
      #
      # @return [AttrList] a list of computed attribute names
      def to_attr_list
        AttrList.new(computation.keys)
      end

      # Returns a ruby literal for this expression.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::TupleComputation[#{Support.to_ruby_literal(computation)}]"
      end
      alias :inspect :to_ruby_literal

    end # class TupleComputation
  end # module Types
end # module Alf

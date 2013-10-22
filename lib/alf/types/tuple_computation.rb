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
      extend Domain::Reuse.new(Hash)

      coercions do |c|
        c.delegate :to_tuple_computation
        c.upon(lambda{|v,_| v.respond_to?(:to_hash)}){|arg,_|
          TupleComputation.new Hash[arg.to_hash.map{|k,v|
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

      reuse :to_hash, :map, :empty?

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
        hmap{|_,v| v.is_a?(TupleExpression) ? v.evaluate(scope) : v }
      end

      # Projects this tuple computation on specified attribute names.
      #
      # @param [AttrList] attributes some attribute names.
      # @param [Boolean] allbut apply a allbut projection?
      def project(attributes, allbut = false)
        TupleComputation.new\
          AttrList.coerce(attributes).project_tuple(reused_instance, allbut)
      end

      # Returns self
      def to_tuple_computation
        self
      end

      # Converts to a heading.
      #
      # @return [AttrList] a computed heading from static analysis of expressions
      def to_heading
        Heading.new hmap{|_,v| v.is_a?(TupleExpression) ? v.infer_type : v.class}
      end

      # Converts to an attribute list.
      #
      # @return [AttrList] a list of computed attribute names
      def to_attr_list
        AttrList.new(reused_instance.keys)
      end

      # Returns a lispy expression.
      #
      # @return [String] a lispy expression for this tuple computation
      def to_lispy
        "{" << map{|k,v| "#{k}: #{Support.to_lispy(v)}" }.join(', ') << "}"
      end

      # Returns a ruby literal for this expression.
      #
      # @return [String] a literal s.t. `eval(self.to_ruby_literal) == self`
      def to_ruby_literal
        "Alf::TupleComputation[#{to_lispy[1...-1]}]"
      end
      alias :inspect :to_ruby_literal
      alias :to_s :to_ruby_literal

    private

      def hmap(&bl)
        map.each_with_object({}){|(k,v),h| h[k] = yield(k,v)}
      end

    end # class TupleComputation
  end # module Types
end # module Alf

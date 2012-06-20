module Alf
  module Types
    #
    # Specialization of TupleExpression to boolean expressions.
    #
    class TuplePredicate < TupleExpression

      class << self

        # Coerces `arg` to a TuplePredicate
        #
        # Implemented coercions are:
        # - TuplePredicate    -> self
        # - TupleExpression   -> Renewed on this class
        # - true and false    -> true and false predicates
        # - Proc              -> TuplePredicate(arg, nil)
        # - String and Symbol -> as for TupleExpression
        # - empty Array       -> coerce(true)
        # - singleton Array   -> coerce(arg.first)
        # - {"attr" => "value", ...} -> equal predicate with coercions
        # - {:attr  => ...value..., ...} -> equal predicate without coercions
        #
        # @param [Object] arg the value to coerce to a TuplePredicate
        # @return [TuplePredicate] the predicate if coercion succeeds
        # @raise [ArgumentError] if coercion fails
        def coerce(arg)
          case arg
          when TuplePredicate
            arg
          when TupleExpression
            TuplePredicate.new arg.expr_lambda, arg.source
          when TrueClass, FalseClass
            TuplePredicate.new lambda{ arg }, arg.to_s
          when Proc
            TuplePredicate.new arg, nil
          when String, Symbol
            TuplePredicate.new eval("lambda{ #{arg} }"), arg
          when Hash
            h = Hash[arg.map{|k,v|
              (AttrName === k) ?
                [k,v] : [Tools.coerce(k, AttrName), Kernel.eval(v)]
            }]
            source = h.map{|k,v|
              "(self.#{k} == #{Tools.to_ruby_literal(v)})"
            }.join(" && ")
            TuplePredicate.new eval("lambda{ #{source} }"), source
          when Array
            (arg.size <= 1) ?
              coerce(arg.first || true) :
              coerce(Hash[*arg])
          else
            raise ArgumentError, "Invalid argument `#{arg}` for TupleExpression()"
          end
        end
        alias :[] :coerce

        # Convert commandline arguments to a tuple predicate
        #
        # This method reuses `coerce(Array)` and therefore shares its spec.
        #
        # @param [Array] args commandline arguments
        # @param [Hash] opts coercion options (not used).
        # @return [TuplePredicate] the predicate if coercion succeeds
        # @raise [ArgumentError] if the coercion fails.
        def from_argv(argv)
          coerce(argv)
        end

      end # class << self

    end # class TuplePredicate
  end # module Types
end # module Alf

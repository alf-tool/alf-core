module Alf
  module Tools

    # Converts `value` to a ruby literal
    #
    # This method is provided for code generation mechanisms used by Alf in
    # various places (such as .rash files). The to_ruby_literal contract is
    # such that the following invariant holds:
    #
    #     eval(to_ruby_literal(value)) == value
    #
    # This contract is ensured by Myrrha::ToRubyLiteral for various ruby values.
    # Myrrha delegates the job to `value.to_ruby_literal` provided this method 
    # exists. In such case, the implementation must be such that the invariant
    # above is met.
    #
    # In every case, an invocation to this method only makes sense provided that
    # `value` denotes a pure value, with the obvious semantics (from TTM).
    #
    # @param [Object] value any ruby object that denotes a pure value.
    # @return [String] a ruby literal for `value`
    def to_ruby_literal(value)
      ToRubyLiteral.apply(value)
    end

    # Myrrha rules for converting to ruby literals
    ToRubyLiteral = Myrrha::ToRubyLiteral.dup.append do
    end

  end # module Tools
end # module Alf

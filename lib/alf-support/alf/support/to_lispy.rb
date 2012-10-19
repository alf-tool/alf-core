module Alf
  module Support

    # Converts `value` to a lispy expression.
    #
    # Example:
    #
    #     expr = Alf.examples.compile{
    #       project(:suppliers, [:name])
    #     }
    #     Support.to_lispy(expr)
    #     # => project(:suppliers, [:name])
    #
    # @param [Object] expr any ruby object denoting a lispy expression
    # @return [String] a lispy expression for `value`
    def to_lispy(expr)
      ToLispy.apply(expr)
    end

    # Myrrha rules for converting to ruby literals
    ToLispy = Myrrha::coercions do |r|

      # Delegate to #to_lispy if it exists
      lispy_able = lambda{|v,rd| v.respond_to?(:to_lispy)}
      r.upon(lispy_able) do |v,rd|
        v.to_lispy
      end

      # Let's assume to to_ruby_literal will make the job
      r.fallback(Object) do |v, _|
        Support.to_ruby_literal(v) rescue v.inspect
      end

    end # ToLispy

  end # module Support
end # module Alf

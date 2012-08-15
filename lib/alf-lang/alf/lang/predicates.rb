module Alf
  module Lang
    module Predicates

      [ :tautology, :contradiction,
        :in, :eq, :neq,
        :lt, :lte, :gt, :gte, :between ].each do |m|

        define_method(m) do |*args|
          Predicate.send(m, *args)
        end

      end

    end # module Predicates
  end # module Lang
end # module Alf

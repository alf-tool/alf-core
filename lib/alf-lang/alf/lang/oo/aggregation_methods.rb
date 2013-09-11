module Alf
  module Lang
    module ObjectOriented
      module AggregationMethods

        def self.def_aggregator_method(name, clazz)
          define_method(name) do |*args, &block|
            clazz.new(*args, &block).aggregate(_self_operand.to_cog)
          end
        end

        Aggregator.listen do |name, clazz|
          def_aggregator_method(name, clazz)
        end

      end # module AggregationMethods
    end # module ObjectOriented
  end # module Lang
end # module Alf

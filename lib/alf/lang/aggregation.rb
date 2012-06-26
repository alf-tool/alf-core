module Alf
  module Lang
    module Aggregation

      Aggregator.listen do |agg_name, agg_class|
        define_method(agg_name) do |*args, &block|
          agg_class.new(*args, &block)
        end
      end

    end # module Aggregation
  end # module Lang
end # module Alf

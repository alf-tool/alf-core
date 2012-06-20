module Alf
  module Lang
    module Aggregation

      # Install the DSL through iteration over defined aggregators
      Aggregator.each do |agg_class|
        agg_name = Tools.ruby_case(Tools.class_name(agg_class)).to_sym
        if method_defined?(agg_name)
          raise "Unexpected method clash on Alf::Lang##{agg_name}"
        end

        define_method(agg_name) do |*args, &block|
          agg_class.new(*args, &block)
        end
      end

    end # module Aggregation
  end # module Lang
end # module Alf

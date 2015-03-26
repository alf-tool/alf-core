module Alf
  module Lang
    module Aggregators

      class << self
        def def_aggregator_method(name, clazz)
          define_method(name) do |*args, &block|
            clazz.new(*args, &block)
          end
        end
      end

      Aggregator.listen do |name, clazz|
        def_aggregator_method(name, clazz)
      end

    end # module Aggregators
  end # module Lang
end # module Alf

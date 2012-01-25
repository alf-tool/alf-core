module Alf
  class Aggregator
    #
    # This module installs class-level utilities of Alf's aggregators.
    #
    # Subclasses of Aggregator are automatically tracked so as to add
    # factory methods on the Aggregator class itself. Example: 
    #
    #   class Sum < Aggregate   # will give a method Aggregator.sum
    #     ...
    #   end
    #   Aggregator.sum{ size }
    #
    # All registered aggregators are available under `Aggregator.aggregators`
    # Those aggregators may also be iterated as follows:
    #
    #   Alf::Aggregator.each do |agg_class|
    #
    #     # agg_class is a subclass of Aggregator
    #
    #   end
    #
    module ClassMethods

      # Returns registered aggregators as an Array of classes
      #
      # @return [Array<Class>] The list of registered aggregator classes
      def aggregators
        @aggregators ||= []
      end

      # Yields each aggregator class in turn
      def each
        aggregators.each(&Proc.new)
      end

      # Automatically installs factory methods for inherited classes.
      #
      # @param [Class] clazz a class that extends Aggregator
      def inherited(clazz)
        basename = Tools.ruby_case(Tools.class_name(clazz))
        Aggregator.module_eval do
          aggregators << clazz
        end
        Aggregator.module_eval <<-EOF
          def self.#{basename}(*args, &block)
            #{clazz}.new(*args, &block)
          end
        EOF
      end

      # Coerces `arg` to an Aggregator
      #
      # Implemented coercions are:
      # - Aggregator -> self
      # - String     -> through factory methods on self
      #
      # @param [Object] arg a value to coerce to an aggregator
      # @return [Aggregator] the coerced aggregator
      # @raise [ArgumentError] if the coercion fails
      def coerce(arg)
        case arg
        when Aggregator
          arg
        when String
          agg = instance_eval(arg)
          agg.source = arg
          agg
        else
          raise ArgumentError, "Invalid arg `arg` for Aggregator()"
        end
      end
        
    end # module ClassMethods
    extend(ClassMethods)
  end # class Aggregator
end # module Alf

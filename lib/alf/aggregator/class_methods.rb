module Alf
  class Aggregator
    module ClassMethods
      
      #
      # Automatically installs factory methods for inherited classes.
      #
      # Example: 
      #   class Sum < Aggregate   # will give a method Aggregator.sum
      #     ...
      #   end
      #   Aggregator.sum{ size }
      # 
      def inherited(clazz)
        basename = Tools.ruby_case(Tools.class_name(clazz))
        instance_eval <<-EOF
          def #{basename}(*args, &block)
            #{clazz}.new(*args, &block)
          end
        EOF
      end
  
      #
      # Coerces `arg` as an Aggregator
      #
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

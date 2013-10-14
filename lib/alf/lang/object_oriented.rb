require_relative 'oo/aggregation_methods'
require_relative 'oo/algebra_methods'
require_relative 'oo/rendering_methods'
module Alf
  module Lang
    module ObjectOriented
      include AggregationMethods
      include AlgebraMethods
      include RenderingMethods

      def self.new(self_operand)
        Module.new{
          include ObjectOriented
          define_method(:_self_operand) do
            self_operand
          end
          define_method(:to_cog) do
            self_operand.to_cog
          end
          private :_self_operand
        }
      end

    end # module ObjectOriented
  end # module Lang
end # module Alf

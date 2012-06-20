module Alf
  module Operator
    module NonRelational

      # Yields the block with each operator module in turn
      def self.each
        constants.each do |c|
          val = const_get(c)
          yield(val) if val.ancestors.include?(Operator::NonRelational)
        end
      end

    end # NonRelational
  end # module Operator
end # module Alf
require_relative 'non_relational/autonum'
require_relative 'non_relational/defaults'
require_relative 'non_relational/compact'
require_relative 'non_relational/sort'
require_relative 'non_relational/clip'
require_relative 'non_relational/coerce'
require_relative 'non_relational/generator'

module Alf
  #
  # Namespace for all operators, relational and non-relational ones.
  # 
  module Operator
    include Iterator, Tools

    # Operator factory
    def Alf.Operator()
      Alf.Command() do |b|
        b.instance_module Alf::Operator
      end
    end

    require 'alf/operator/class_methods'
    require 'alf/operator/signature'
    require 'alf/operator/base'
    require 'alf/operator/nullary'
    require 'alf/operator/unary'
    require 'alf/operator/binary'
    require 'alf/operator/cesure'
    require 'alf/operator/transform'
    require 'alf/operator/shortcut'
    require 'alf/operator/experimental'

    # Namespace for non relational operators
    module NonRelational
      require 'alf/operator/non_relational/autonum'
      require 'alf/operator/non_relational/defaults'
      require 'alf/operator/non_relational/compact'
      require 'alf/operator/non_relational/sort'
      require 'alf/operator/non_relational/clip'
      require 'alf/operator/non_relational/coerce'
      require 'alf/operator/non_relational/generator'

      # Yields the block with each operator module in turn
      def self.each
        constants.each do |c|
          val = const_get(c)
          yield(val) if val.ancestors.include?(Operator::NonRelational)
        end
      end
    end # NonRelational
    
    #
    # Marker module and namespace for relational operators
    #
    module Relational
      require 'alf/operator/relational/extend'
      require 'alf/operator/relational/project'
      require 'alf/operator/relational/restrict'
      require 'alf/operator/relational/rename'
      require 'alf/operator/relational/union'
      require 'alf/operator/relational/minus'
      require 'alf/operator/relational/intersect'
      require 'alf/operator/relational/join'
      require 'alf/operator/relational/matching'
      require 'alf/operator/relational/not_matching'
      require 'alf/operator/relational/wrap'
      require 'alf/operator/relational/unwrap'
      require 'alf/operator/relational/group'
      require 'alf/operator/relational/ungroup'
      require 'alf/operator/relational/summarize'
      require 'alf/operator/relational/rank'
      require 'alf/operator/relational/quota'
      require 'alf/operator/relational/heading'

      # Yields the block with each operator module in turn
      def self.each
        constants.each do |c|
          val = const_get(c)
          yield(val) if val.ancestors.include?(Operator::Relational)
        end
      end
    end # module Relational
    
  end # module Operator
end # module Alf

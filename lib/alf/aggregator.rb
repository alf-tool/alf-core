module Alf
  #
  # Aggregation operator.
  #
  class Aggregator
    require 'alf/aggregator/class_methods'
    require 'alf/aggregator/instance_methods'
    require 'alf/aggregator/count'
    require 'alf/aggregator/sum'
    require 'alf/aggregator/min'
    require 'alf/aggregator/max'
    require 'alf/aggregator/avg'
    require 'alf/aggregator/variance'
    require 'alf/aggregator/stddev'
    require 'alf/aggregator/collect'
    require 'alf/aggregator/concat'

  end # class Aggregator
end # module Alf

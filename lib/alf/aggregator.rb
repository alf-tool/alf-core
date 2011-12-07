module Alf
  #
  # Aggregation operator.
  #
  # This class provides a basis for implementing aggregation operators. It 
  # should always be used as a superclass for such implementations. See 
  # ClassMethods and InstanceMethods for implementing your own aggregation 
  # operators.
  #
  # Aggregation operators are made available through factory methods on the 
  # Aggregator class itself:
  #
  #     Aggregator.count
  #     Aggregator.sum{ qty }
  #
  # The coercion method should always be used for building aggregators from 
  # lispy source code:
  #
  #     Aggregator.coerce("count")
  #     Aggregator.coerce("sum{ qty }")
  #
  # Once built, aggregators can be used either in black-box or white-box modes.
  #
  #     relation = ...
  #     agg = Aggregator.sum{ qty }
  #
  #     # Black box mode:
  #     result = agg.aggregate(relation)
  #
  #     # White box mode:
  #     memo = agg.least
  #     relation.each do |tuple|
  #       memo = agg.happens(memo, tuple)
  #     end
  #     result = agg.finalize(memo)
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

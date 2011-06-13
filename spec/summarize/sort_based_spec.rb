require File.expand_path('../../spec_helper', __FILE__)
class Alf
  describe Summarize::SortBased do
      
    let(:input) {[
      {:a => "via_method", :time => 1},
      {:a => "via_method", :time => 1},
      {:a => "via_method", :time => 2},
      {:a => "via_reader", :time => 4},
      {:a => "via_reader", :time => 2},
    ]}

    let(:expected) {[
      {:a => "via_method", :time_sum => 4, :time_max => 2},
      {:a => "via_reader", :time_sum => 6, :time_max => 4},
    ]}

    let(:by_key){ ProjectionKey.new([:a],false) }
    let(:aggs){{:time_sum => Aggregator.sum(:time),
                :time_max => Aggregator.max(:time)}} 
    let(:operator){ Summarize::SortBased.new(by_key, aggs) }

    before{ operator.input = input }
    subject{ operator.to_a }

    it { should == expected }

  end 
end

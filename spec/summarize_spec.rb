require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Summarize do
      
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

    subject{ operator.to_a }

    describe "When factored with Lispy" do
      let(:aggs){{:time_sum => Aggregator.sum(:time),
                  :time_max => Aggregator.max(:time)}} 
      let(:operator){ Lispy.summarize(input, [:a], aggs) }
      it { should == expected }
    end

    describe "When factored with Lispy II" do
      let(:operator){ 
        Lispy.summarize(input, [:a]){
          {:time_sum => Aggregator.sum(:time),
           :time_max => Aggregator.max(:time)}
        }
      }
      it { should == expected }
    end

  end 
end
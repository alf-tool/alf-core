require File.expand_path('../spec_helper', __FILE__)
module Alf
  describe Compact do
      
    let(:input) {[
      {:a => "via_method", :time => 1, :b => "b"},
      {:a => "via_reader", :time => 3, :b => "b"},
      {:a => "via_method", :time => 2, :b => "b"},
      {:a => "via_reader", :time => 3, :b => "b"},
      {:a => "via_method", :time => 1, :b => "b"},
    ]}

    let(:expected) {[
      {:a => "via_method", :time => 1, :b => "b"},
      {:a => "via_reader", :time => 3, :b => "b"},
      {:a => "via_method", :time => 2, :b => "b"},
    ]}

    subject{ operator.to_a }

    describe "when factored with commandline args" do
      let(:operator){ Compact.run(%w{}) }
      before{ operator.pipe(input) }
      it { should == expected }
    end

    describe "when factored with Lispy" do
      let(:operator){ Lispy.compact(input) }
      it { should == expected }
    end

  end 
end

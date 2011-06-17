require 'spec_helper'
module Alf
  describe Ungroup do
      
    let(:operator_class){ Ungroup }
    it_should_behave_like("An operator class")
      
    let(:input) {[
      {:a => "via_method", :as => [{:time => 1, :b => "b"}, {:time => 2, :b => "b"}]},
      {:a => "via_reader", :as => [{:time => 3, :b => "b"}]},
    ]}

    let(:expected) {[
      {:a => "via_method", :time => 1, :b => "b"},
      {:a => "via_method", :time => 2, :b => "b"},
      {:a => "via_reader", :time => 3, :b => "b"},
    ]}

    subject{ operator.to_a.sort{|k1,k2| k1[:time] <=> k2[:time]} } 

    describe "when factored with commandline args" do
      let(:operator) { Ungroup.run(%w{-- as}) } 
      before{ operator.pipe(input) }
      it { should == expected }
    end

    describe "when factored with Lispy" do
      let(:operator) { Lispy.ungroup(input, :as) } 
      it { should == expected }
    end

  end 
end

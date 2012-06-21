require 'spec_helper'
module Alf
  module Operator::Relational
    describe Group do

      let(:operator_class){ Group }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_method", :time => 2, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
      ]}

      let(:expected) {[
        {:a => "via_method", :as => Alf::Relation[{:time => 1, :b => "b"}, 
                                                  {:time => 2, :b => "b"}]},
        {:a => "via_reader", :as => Alf::Relation[{:time => 3, :b => "b"}]},
      ]}

      subject{ operator.to_a.sort{|k1,k2| k1[:a] <=> k2[:a]} }

      context "--no-allbut" do
        context "with Lispy" do
          let(:operator){ a_lispy.group(input, [:time, :b], :as) }
          it { should == expected }
        end
      end # --no-allbut
  
      context "--allbut" do
        context "with Lispy" do
          let(:operator){ a_lispy.group(input, [:a], :as, :allbut => true) }
          it { should == expected }
        end
      end # --allbut

    end 
  end
end

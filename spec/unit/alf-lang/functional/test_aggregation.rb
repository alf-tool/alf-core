require 'spec_helper'
module Alf
  module Lang
    describe "Aggregation methods" do
      include Functional

      let(:input){[
        {:tested => 1,  :other => "b"},
        {:tested => 30, :other => "a"},
      ]}

      let(:expected){[
        {:tested => 30, :other => "a", :upcase => "A"},
      ]}

      context 'on sum' do
        it "should have sum with immediate block" do
          sum{|t| t.qty }.should be_a(Aggregator::Sum)
        end

        it "should have sum with a Proc" do
          sum(->(t){ qty }).should be_a(Aggregator::Sum)
        end
      end

      context 'on concat' do
        it "should have concat with immediate block" do
          concat{|t| t.name }.should be_a(Aggregator::Concat)
        end

        it "should have sum with a Proc" do
          agg = concat(->(t){ t.name }, between: ', ')
          agg.should be_a(Aggregator::Concat)
          agg.options[:between].should eq(', ')
        end
      end

    end
  end
end
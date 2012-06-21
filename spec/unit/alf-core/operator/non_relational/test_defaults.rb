require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Defaults do

      let(:operator_class){ Defaults }
      it_should_behave_like("An operator class")

      subject{ operator.to_a }

      context "--no-strict" do
        let(:input) {[
          {:a => nil, :b => "b"},
        ]}
        let(:expected) {[
          {:a => 1, :b => "b", :c => "blue"},
        ]}

        context "with Lispy" do 
          let(:operator){ a_lispy.defaults(input, :a => 1, :c => "blue") }
          it{ should == expected }
        end

      end # --no-strict

      describe "--strict" do
        let(:input) {[
          {:a => 3,   :b => "b", :c => "blue"},
          {:a => nil, :b => "b", :c => "blue"},
        ]}
        let(:expected) {[
          {:a => 3, :b => "b"},
          {:a => 1, :b => "b"},
        ]}

      end # --strict

      context "with tuple expressions" do
        let(:input) {[
          {:a => nil, :b => "b"},
        ]}
        let(:expected) {[
          {:a => "b", :b => "b"},
        ]}
        let(:operator){ 
          a_lispy.defaults(input, {:a => TupleExpression.coerce("b")}) 
        }
        it{ should == expected }
      end # tuple expressions

    end
  end
end

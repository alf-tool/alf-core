require 'spec_helper'
module Alf
  module Operator::Relational
    describe Rank do

      let(:operator_class){ Rank }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:pid => 'P1', :weight => 12.0},
        {:pid => 'P2', :weight => 17.0},
        {:pid => 'P3', :weight => 17.0},
        {:pid => 'P4', :weight => 14.0},
        {:pid => 'P5', :weight => 12.0},
        {:pid => 'P6', :weight => 19.0}
      ]}

      subject{ operator.to_rel }

      context "with partial ordering" do
        let(:expected) {Alf::Relation[
          {:pid => 'P1', :weight => 12.0, :rank => 0},
          {:pid => 'P5', :weight => 12.0, :rank => 0},
          {:pid => 'P4', :weight => 14.0, :rank => 2},
          {:pid => 'P2', :weight => 17.0, :rank => 3},
          {:pid => 'P3', :weight => 17.0, :rank => 3},
          {:pid => 'P6', :weight => 19.0, :rank => 5}
        ]}
        let(:operator){ a_lispy.rank(input, [:weight]) }
        it{ should eq(expected) }
      end # partial ordering

      describe "with total ordering" do
        let(:expected) {Alf::Relation[
          {:pid => 'P1', :weight => 12.0, :newname => 0},
          {:pid => 'P5', :weight => 12.0, :newname => 1},
          {:pid => 'P4', :weight => 14.0, :newname => 2},
          {:pid => 'P2', :weight => 17.0, :newname => 3},
          {:pid => 'P3', :weight => 17.0, :newname => 4},
          {:pid => 'P6', :weight => 19.0, :newname => 5}
        ]}
        let(:operator){ a_lispy.rank(input, [:weight, :pid], :newname) }
        it{ should eq(expected) }
      end # total ordering

    end
  end
end

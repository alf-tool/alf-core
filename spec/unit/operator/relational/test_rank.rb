require 'spec_helper'
module Alf
  module Operator::Relational
    describe Rank do
        
      let(:operator_class){ Rank }
      it_should_behave_like("An operator class")
        
      let(:input) {Alf::Relation[
        {:pid => 'P1', :weight => 12.0},
        {:pid => 'P2', :weight => 17.0},
        {:pid => 'P3', :weight => 17.0},
        {:pid => 'P4', :weight => 14.0},
        {:pid => 'P5', :weight => 12.0},
        {:pid => 'P6', :weight => 19.0}
      ]}
  
      subject{ operator.to_rel }

      describe "when a partial ordering is used" do
        let(:expected) {Alf::Relation[
          {:pid => 'P1', :weight => 12.0, :rank => 0},
          {:pid => 'P5', :weight => 12.0, :rank => 0},
          {:pid => 'P4', :weight => 14.0, :rank => 2},
          {:pid => 'P2', :weight => 17.0, :rank => 3},
          {:pid => 'P3', :weight => 17.0, :rank => 3},
          {:pid => 'P6', :weight => 19.0, :rank => 5}
        ]}
        let(:operator){ Rank.new([:weight]) }
        before{ operator.pipe(input) }
        it{ 
          should eq(expected) 
        }
      end
          
    end
  end
end
require 'spec_helper'
module Alf
  module Operator::Relational
    describe Union do
        
      let(:operator_class){ Union }
      it_should_behave_like("An operator class")
        
      let(:left) {[
        {:city => 'London'},
        {:city => 'Paris'},
        {:city => 'Paris'}
      ]}
  
      let(:right) {[
        {:city => 'Oslo'},
        {:city => 'Paris'}
      ]}
  
      let(:operator){ Union.run([]) }
      subject{ operator.to_a }
  
      describe "when applied on non disjoint sets" do
        before{ operator.pipe [left, right] }
        let(:expected){[
          {:city => 'London'},
          {:city => 'Paris'},
          {:city => 'Oslo'}
        ]}
        it { should == expected }
      end
  
    end 
  end
end
require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Coerce do
  
      let(:operator_class){ Coerce }
      it_should_behave_like("An operator class")
        
      let(:input) {Alf::Relation[
        {:a => "12", :b => "14.0"},
      ]}
  
      subject{ operator.to_rel }
  
      describe "When used without --strict" do
        let(:expected){Alf::Relation[
          {:a => 12, :b => 14.0}
        ]}
        
        describe "when factored from commandline" do
          let(:operator){ Coerce.run(%w{-- a Integer b Float}) }
          before{ operator.pipe(input) }
          it { should == expected } 
        end
  
        describe "when factored with Lispy" do
          let(:operator){ Lispy.coerce(input, :a => Integer, :b => Float) }
          it { should == expected } 
        end
  
      end
  
    end 
  end
end

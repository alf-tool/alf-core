require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Defaults do
      
      let(:operator_class){ Defaults }
      it_should_behave_like("An operator class")
        
      subject{ operator.to_a }
  
      describe "when used without --strict" do
        
        let(:input) {[
          {:a => nil, :b => "b"},
        ]}
    
        let(:expected) {[
          {:a => 1, :b => "b", :c => "blue"},
        ]}
    
        describe "When factored with Lispy" do 
          let(:operator){ Lispy.defaults(input, :a => 1, :c => "blue") }
          it{ should == expected }
        end
    
        describe "When factored from commandline args" do
          let(:operator){ Defaults.run(%w{-- a 1 c 'blue'}) }
          before{ operator.pipe(input) }
          it{ should == expected }
        end
  
      end
        
      describe "when used with --strict" do
        
        let(:input) {[
          {:a => nil, :b => "b", :c => "blue"},
        ]}
    
        let(:expected) {[
          {:a => 1, :b => "b"},
        ]}
    
        describe "When factored with Lispy" do 
          let(:operator){ Lispy.defaults(input, {:a => 1, :b => "b"}, true) }
          it{ should == expected }
        end
    
      end
        
    end 
  end
end
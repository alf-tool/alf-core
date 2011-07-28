require 'spec_helper'
module Alf
  module Tools
    describe TupleComputation do
  
      describe "coerce" do
      
        subject{ TupleComputation.coerce(arg) }
        
        describe "from a TupleComputation" do
          let(:arg){ TupleComputation.new :hello => TupleExpression.coerce(:who) } 
          it{ should be_a(TupleComputation) }
          specify{ subject.compute(:who => "alf").should eql(:hello => "alf") } 
        end
        
        describe "from a Hash" do
          let(:arg){ 
            {:hello  => TupleExpression.coerce(:who),
             :hello2 => lambda{ who },
             :hello3 => :who}
          }
          let(:expected){
            {:hello => "alf", :hello2 => "alf", :hello3 => "alf"}
          }
          it{ should be_a(TupleComputation) }
          specify{ subject.compute(:who => "alf").should eql(expected) }
        end
        
        describe "from an Array" do
          let(:arg){ ["hello", "who"] }
          let(:expected){
            {:hello => "alf"}
          }
          it{ should be_a(TupleComputation) }
          specify{ subject.compute(:who => "alf").should eql(expected) }
        end
          
      end
      
    end
  end
end
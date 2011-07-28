require 'spec_helper'
module Alf
  module Tools
    describe TupleComputation do
  
      let(:handle){ TupleHandle.new.set(:who => "alf") }
      subject{ TupleComputation.coerce(arg).evaluate(handle) }
      
      describe "from a TupleComputation" do
        let(:arg){ TupleComputation.new :hello => TupleExpression.coerce(:who) } 
        it{ should eql(:hello => "alf") } 
      end
        
      describe "from a Hash without coercion" do
        let(:arg){ 
          {:hello  => TupleExpression.coerce(:who),
           :hello2 => lambda{ who },
           :hello3 => :who}
        }
        let(:expected){
          {:hello => "alf", :hello2 => "alf", :hello3 => "alf"}
        }
        it{ should eql(expected) }
      end
        
      describe "from an Array with coercions" do
        let(:arg){ ["hello", "who"] }
        let(:expected){
          {:hello => "alf"}
        }
        it{ should eql(expected) }
      end
          
    end
  end
end
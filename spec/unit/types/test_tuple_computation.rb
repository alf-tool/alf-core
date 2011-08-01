require 'spec_helper'
module Alf
  describe TupleComputation do

    let(:handle){ Tools::TupleHandle.new.set(:who => "alf") }
      
    describe "coerce" do
      subject{ TupleComputation.coerce(arg).evaluate(handle) }
      
      describe "from a TupleComputation" do
        let(:arg){ TupleComputation.new :hello => TupleExpression.coerce(:who) } 
        it{ should eql(:hello => "alf") } 
      end
        
      describe "from a Hash without coercion" do
        let(:arg){ 
          {:hello  => TupleExpression.coerce(:who),
           :hello2 => 2,
           :hello3 => lambda{ who } }
        }
        let(:expected){
          {:hello => "alf", :hello2 => 2, :hello3 => "alf"}
        }
        it{ should eql(expected) }
      end
        
      describe "from a Hash with coercion" do
        let(:arg){ 
          {"hello" => "who", "hello2" => "2"}
        }
        let(:expected){
          {:hello => "alf", :hello2 => 2}
        }
        it{ should eql(expected) }
      end
        
      describe "from an Array with coercions" do
        let(:arg){ ["hello", "who", "hello2", "2"] }
        let(:expected){
          {:hello => "alf", :hello2 => 2}
        }
        it{ should eql(expected) }
      end
    end
    
    describe "from_argv" do
      subject{ TupleComputation.from_argv(argv).evaluate(handle) }

      describe "from an Array with coercions" do
        let(:argv){ ["hello", "who", "hello2", "2"] }
        let(:expected){
          {:hello => "alf", :hello2 => 2}
        }
        it{ should eql(expected) }
      end
      
    end
        
  end
end
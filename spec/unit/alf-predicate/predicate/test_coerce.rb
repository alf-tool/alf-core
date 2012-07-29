require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, ".coerce" do

      subject{ Predicate.coerce(arg) }

      describe "from Predicate" do
        let(:arg){ Predicate.new(Factory.tautology) }
      
        it{ should be(arg) }
      end

      describe "from true" do
        let(:arg){ true }

        specify{
          subject.expr.should be_a(Tautology)
        }
      end

      describe "from false" do
        let(:arg){ false }

        specify{
          subject.expr.should be_a(Contradiction)
        }
      end

      describe "from Symbol" do
        let(:arg){ :status }

        specify{
          subject.expr.should be_a(VarRef)
          subject.expr.var_name.should eq(arg)
        }
      end
      
      describe "from Proc" do
        let(:arg){ lambda{ status == 10 } }

        specify{
          subject.expr.should be_a(Native)
          subject.to_proc.should be(arg)
        }
      end
    
      describe "from String" do
        let(:arg){ "status == 10" }

        specify{
          subject.expr.should be_a(Native)
          subject.to_proc.to_ruby_literal.should eq("lambda{ status == 10 }")
        }
      end
      
      describe "from Hash without coercion" do
        let(:arg){ {:status => 10} }

        specify{
          subject.expr.should be_a(Eq)
          subject.expr.should eq([:eq, [:var_ref, :status], [:literal, 10]])
        }
      end
      
      # describe "from Hash with coercion" do
      #   let(:arg){ {"status" => "10"} }
      #   it{ should eql(true) }
      # end
      # 
      # describe "from a singleton Array" do
      #   let(:arg){ ["status == 10"] }
      #   it{ should eql(true) }
      # end
      # 
      # describe "from an Array with coercion" do
      #   let(:arg){ ["status", "10"] }
      #   it{ should eql(true) }
      # end
    
    end
  end
end
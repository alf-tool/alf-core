require 'optimizer_helper'
module Alf
  class Optimizer
    describe Search do

      let(:search){ 
        Search.new(processor, Algebra::Project)
      }

      let(:new_operand){ an_operand }

      let(:processor){
        lambda{|expr, s|
          raise unless expr.is_a?(Algebra::Project)
          raise unless s == search
          new_operand
        }
      }

      subject{ search.call(expr) }

      context "when the expression is a Project" do
        let(:expr){ project(an_operand, [:foo]) }

        it{ should be(new_operand) }
      end

      context "when the expression has no Project at all" do
        let(:expr){ clip(an_operand, [:foo]) }

        it{ should eq(expr) }
      end

      context "when the expression has a Project somewhere" do
        let(:expr){ clip(project(an_operand, [:foo]), [:foo]) }

        specify "the top one should be a Clip" do
          subject.should be_a(Algebra::Clip)
        end

        specify "the internal one has been seen by processor" do
          subject.operand.should be(new_operand)
        end
      end

    end
  end
end
require 'spec_helper'
module Alf
  module Tools
    describe TupleExpression do
  
      describe "coerce" do
        
        subject{ TupleExpression.coerce(arg) }
        let(:plug) {
          o = Object.new
          def o.status
            10
          end
          o
        }
          
        describe "with nil" do
          let(:arg){ nil }
          it { should be_a(TupleExpression) }
          specify{ subject.evaluate(plug).should eql(true) }
        end
        
        describe "with a String" do
          let(:arg){ "true" }
          it { should be_a(TupleExpression) }
          specify{ subject.evaluate(plug).should eql(true) }
        end
        
        describe "with a Symbol" do
          let(:arg){ :status }
          it { should be_a(TupleExpression) }
          specify{ subject.evaluate(plug).should eql(10) }
        end
        
        describe "with a Proc" do
          let(:arg){ lambda{ :hello } }
          it { should be_a(TupleExpression) }
          specify{ subject.evaluate(plug).should eql(:hello) }
        end
        
        describe "with an empty Hash" do
          let(:arg){ {} }
          it { should be_a(TupleExpression) }
          specify{ subject.evaluate(plug).should eql(true) }
        end
        
        describe "with an non empty hash" do
          let(:arg){ {:status => 20} } 
          it { should be_a(TupleExpression) }
          specify{ subject.evaluate(plug).should eql(false) }
        end
        
        describe "with an array" do
          let(:arg){ [:status, 10] }
          it { should be_a(TupleExpression) }
          specify{ subject.evaluate(plug).should eql(true) }
        end
        
      end
        
    end   
  end
end
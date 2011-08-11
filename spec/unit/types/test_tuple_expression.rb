require 'spec_helper'
module Alf
  describe TupleExpression do

    let(:handle) {
      Tools::TupleHandle.new.set(:status => 10)
    }
    
    describe "coerce" do
      
      subject{ TupleExpression.coerce(arg) }
        
      describe "with nil" do
        let(:arg){ nil }
        specify{ lambda{subject}.should raise_error(ArgumentError) }
      end
      
      describe "with a String" do
        let(:arg){ "true" }
        it { should be_a(TupleExpression) }
        specify{ 
          subject.evaluate(handle).should eql(true) 
          subject.source.should eq("true")
        }
      end
      
      describe "with a Symbol" do
        let(:arg){ :status }
        it { should be_a(TupleExpression) }
        specify{ 
          subject.evaluate(handle).should eql(10) 
          subject.source.should eq("status")
        }
      end
      
      describe "with a Proc" do
        let(:arg){ lambda{ :hello } }
        it { should be_a(TupleExpression) }
        specify{ 
          subject.evaluate(handle).should eql(:hello) 
          subject.source.should be_nil
        }
      end
      
    end
    
    describe "from_argv" do
      
      subject{ TupleExpression.from_argv(argv).evaluate(handle) }
        
      describe "with a String" do
        let(:argv){ %w{true} }
        it{ should eql(true) }
      end
        
      describe "with two String" do
        let(:argv){ %w{hello world} }
        specify{ lambda{subject}.should raise_error(ArgumentError) }
      end
      
    end
      
  end   
end

require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, TupleExpression)" do

    let(:scope) {
      Support::TupleScope.new(:status => 10)
    }

    subject{ Shell.from_argv(argv, TupleExpression) }

    context "with a String (1)" do
      let(:argv){ %w{true} }
      it { should be_a(TupleExpression) }
      specify{
        subject.evaluate(scope).should eql(true)
        subject.source.should eq("true")
      }
    end

    context "with a String (2)" do
      let(:argv){ ["status > 10"] }
      it { should be_a(TupleExpression) }
      specify{
        subject.evaluate(scope).should eql(false)
        subject.source.should eq("status > 10")
      }
    end

    context "with two String" do
      let(:argv){ %w{hello world} }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end


  end
end

require 'spec_helper'
module Alf
  describe TupleExpression, "coerce" do

    let(:scope) {
      Support::TupleScope.new(:status => 10)
    }

    subject{ TupleExpression.coerce(arg) }

    describe "with nil" do
      let(:arg){ nil }
      specify{ lambda{ subject }.should raise_error(ArgumentError) }
    end

    describe "with a Symbol" do
      let(:arg){ :status }
      it { should be_a(TupleExpression) }
      specify{
        subject.evaluate(scope).should eql(10)
        subject.source.should eq(:status)
      }
    end

    describe "with a Proc" do
      let(:arg){ lambda{ :hello } }
      it { should be_a(TupleExpression) }
      specify{
        subject.evaluate(scope).should eql(:hello)
        subject.source.should be_nil
      }
    end

  end # TupleExpression
end # Alf

require 'spec_helper'
module Alf
  module Algebra
    describe Rewriter do

      let(:expr){
        l = a_lispy
        l.project(l.rename(an_operand, :firstname => :name), [:name])
      }

      let(:rewriter){
        Rewriter.new
      }

      subject{ rewriter.call(expr) }

      it 'returns an equal expression' do
        subject.should eq(expr)
      end

      it 'makes a deep copy, up to leaf operands' do
        subject.should_not be(expr)
        subject.operand.should_not be(expr.operand)
        subject.operand.operand.should be(expr.operand.operand)
      end

    end
  end
end

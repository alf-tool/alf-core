require 'spec_helper'
module Alf
  class Predicate
    describe Expr, "to_proc" do

      let(:expr){ Factory.lte(:x, 2) }

      subject{ expr.to_proc(options) }

      before do
        subject.should be_a(Proc)
      end

      context "without a scope" do
        let(:options){ {} }

        specify{
          subject.to_ruby_literal.should eq("lambda{ x <= 2 }")
        }
      end

      context "with a scope" do
        let(:options){ {:scope => "t"} }

        specify{
          subject.to_ruby_literal.should eq("lambda{|t| t.x <= 2 }")
        }

        specify{
          subject.call(Struct.new(:x).new(4)).should be_false
          subject.call(Struct.new(:x).new(1)).should be_true
        }
      end

    end
  end
end

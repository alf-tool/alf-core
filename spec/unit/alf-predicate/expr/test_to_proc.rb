require 'spec_helper'
module Alf
  class Predicate
    describe Expr, "to_proc" do

      let(:expr){ Factory.lte(:x, 2) }

      subject{ expr.to_proc }

      before do
        subject.should be_a(Proc)
      end

      specify{
        subject.to_ruby_literal.should eq("lambda{ x <= 2 }")
      }

    end
  end
end

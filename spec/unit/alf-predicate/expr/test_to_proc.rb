require 'spec_helper'
module Alf
  class Predicate
    describe Expr, "to_proc" do

      let(:expr){ Factory.lte(:x, 2) }

      subject{ expr.to_proc }

      it{ should be_a(Proc) }

      it 'has arity 1' do
        subject.arity.should eq(1)
      end

    end
  end
end

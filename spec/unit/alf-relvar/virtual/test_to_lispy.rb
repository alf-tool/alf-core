require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_lispy" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      subject{ rv.to_lispy }

      it 'delegates to the expression' do
        subject.should eq("aname")
      end

    end
  end
end

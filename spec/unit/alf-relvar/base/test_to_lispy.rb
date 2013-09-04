require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_lispy" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      subject{ rv.to_lispy }

      it{ should eq("suppliers") }

    end
  end
end

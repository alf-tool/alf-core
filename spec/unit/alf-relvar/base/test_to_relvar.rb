require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_relvar" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      subject{ rv.to_relvar }

      it{ should be(rv) }

    end
  end
end

require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_relvar" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      subject{ rv.to_relvar }

      it{ should be(rv) }

    end
  end
end

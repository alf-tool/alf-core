require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "expr" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      subject{ rv.expr }

      it{ should be(expr) }

    end
  end
end

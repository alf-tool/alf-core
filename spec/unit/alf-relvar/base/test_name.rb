require 'spec_helper'
module Alf
  module Relvar
    describe Base, "name" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      subject{ rv.name }

      it{ should eq(:suppliers) }

    end
  end
end

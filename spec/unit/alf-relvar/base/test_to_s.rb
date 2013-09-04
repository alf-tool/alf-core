require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_s" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      subject{ rv.to_s }

      it{ should eq("Relvar::Base(:suppliers)") }

    end
  end
end

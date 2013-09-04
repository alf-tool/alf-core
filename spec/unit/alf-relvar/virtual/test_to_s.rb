require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_s" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      subject{ rv.to_s }

      it{ should eq("Relvar::Virtual(Operand::Named(:aname))") }

    end
  end
end

require 'spec_helper'
module Alf
  module Relvar
    describe Base, "connection" do

      let(:expr){
        Algebra::Operand::Named.new(:aname, :aconn)
      }

      let(:rv){
        Base.new(expr)
      }

      subject{ rv.connection }

      it{ should eq(:aconn) }

    end
  end
end

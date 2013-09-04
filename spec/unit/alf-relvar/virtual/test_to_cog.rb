require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_cog" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      subject{ rv.to_cog }

      def cog(expr)
        [:seen, expr]
      end

      it{ should eq([:seen, expr]) }

    end
  end
end

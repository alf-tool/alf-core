require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_cog" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      subject{ rv.to_cog(12) }

      def cog(*args)
        @seen = args
      end

      it{ should eq([12, expr]) }

    end
  end
end

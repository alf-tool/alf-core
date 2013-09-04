require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_cog" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      def cog(*args)
        @seen = args
      end

      subject{ rv.to_cog }

      it 'delegates to the connection' do
        subject
        @seen.should eq([:suppliers, rv])
      end

    end
  end
end

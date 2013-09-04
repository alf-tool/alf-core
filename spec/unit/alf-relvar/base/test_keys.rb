require 'spec_helper'
module Alf
  module Relvar
    describe Base, "keys" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      def keys(*args)
        @seen = args
      end

      subject{ rv.keys }

      it 'delegates to the connection' do
        subject
        @seen.should eq([:suppliers])
      end

    end
  end
end

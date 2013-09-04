require 'spec_helper'
module Alf
  module Relvar
    describe Base, "insert" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      def lock(*args)
        yield(args)
      end

      subject{ rv.lock(:exclusive){|args| @seen = args } }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, :exclusive])
      end

    end
  end
end

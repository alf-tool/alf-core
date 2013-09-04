require 'spec_helper'
module Alf
  module Relvar
    describe Base, "heading" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr) }

      def heading(*args)
        @seen = args
      end

      subject{ rv.heading }

      it 'delegates to the connection' do
        subject
        @seen.should eq([:suppliers])
      end

    end
  end
end

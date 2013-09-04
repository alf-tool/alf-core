require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "keys" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      def keys(name)
        "some keys for #{name}"
      end

      subject{ rv.keys }

      it 'delegates to the expression' do
        subject.should eq("some keys for aname")
      end

    end
  end
end

require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "heading" do

      let(:expr){ Algebra::Operand::Named.new(:aname, self) }
      let(:rv)  { Virtual.new(expr)                         }

      def heading(name)
        "a heading for #{name}"
      end

      subject{ rv.heading }

      it 'delegates to the expression' do
        subject.should eq("a heading for aname")
      end

    end
  end
end

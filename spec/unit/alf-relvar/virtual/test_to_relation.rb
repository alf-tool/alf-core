require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_relation" do

      let(:rv){ Virtual.new(:expr, self) }

      subject{ rv.to_relation }

      def compile(expr)
        Struct.new(:to_relation).new("a relation")
      end

      it{ should eq("a relation") }

    end
  end
end

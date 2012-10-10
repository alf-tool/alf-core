require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_cog" do

      let(:rv){ Virtual.new(:expr, self) }

      subject{ rv.to_cog }

      def cog(expr)
        [expr]
      end

      it{ should eq([:expr]) }

    end
  end
end

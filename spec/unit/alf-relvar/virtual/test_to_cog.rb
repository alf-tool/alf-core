require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_cog" do

      let(:rv){ Virtual.new(self, :expr) }

      subject{ rv.to_cog }

      def optimizer
        lambda{|*args| args }
      end

      def compiler
        lambda{|*args| args }
      end

      it{ should eq([[:expr]]) }

    end
  end
end

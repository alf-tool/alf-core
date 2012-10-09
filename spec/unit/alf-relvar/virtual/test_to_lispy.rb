require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_lispy" do

      let(:rv){ Virtual.new(self, :connection) }

      def to_lispy
        "a lispy expression"
      end

      subject{ rv.to_lispy }

      it 'delegates to the expression' do
        subject.should eq("a lispy expression")
      end

    end
  end
end

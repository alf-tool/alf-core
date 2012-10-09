require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "heading" do

      let(:rv){ Virtual.new(self, :connection) }

      def heading
        "a heading"
      end

      subject{ rv.heading }

      it 'delegates to the expression' do
        subject.should eq("a heading")
      end

    end
  end
end

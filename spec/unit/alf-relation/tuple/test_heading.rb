require 'spec_helper'
module Alf
  describe Tuple, "heading" do

    subject{ tuple.heading }

    describe 'on a tuple factored through an explicit type' do
      let(:tuple){ Tuple[status: Integer].new(status: 12) }

      it{ should eq(Heading.new(status: Integer)) }
    end

    describe 'on a tuple factored through coercion' do
      let(:tuple){ Tuple.coerce(status: 12) }

      it{ should eq(Heading.new(status: Fixnum)) }
    end

  end
end
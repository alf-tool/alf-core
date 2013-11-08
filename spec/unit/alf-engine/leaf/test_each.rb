require 'spec_helper'
module Alf
  module Engine
    describe Leaf, 'each' do

      let(:input) {[
        {"foo" => "bar"},
      ]}

      let(:leaf){
        Leaf.new(input)
      }

      subject{ leaf.each.to_a }

      let(:expected) {[
        {foo: "bar"}
      ]}

      it{ should eq(expected) }

    end
  end
end

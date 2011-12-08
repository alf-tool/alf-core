require 'spec_helper'
module Alf
  module Engine
    describe Unwrap do

      let(:input) {[
        {:wrapped => {:a => "a", :b => "b"}, :c => "c"}
      ]}

      let(:expected) {[
        {:a => "a", :b => "b", :c => "c"},
      ]}

      it "should unwrap as expected" do
        Unwrap.new(input, :wrapped).to_a.should eq(expected)
      end

    end
  end
end

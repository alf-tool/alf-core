require 'spec_helper'
module Alf
  module Lang
    describe "Tuple(...) literal" do
      include Functional

      subject{ Tuple(h) }

      describe 'on an empty tuple' do
        let(:h){ {} }
        it{ should eq(Tuple::EMPTY) }
      end

      describe 'on an valid tuple' do
        let(:h){ {:name => "Alf"} }
        it{ should eq(Tuple(name: "Alf")) }
      end

    end
  end
end

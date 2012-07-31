require 'spec_helper'
module Alf
  module Lang
    describe "Tuple(...) literal" do
      include Functional

      subject{ Tuple(h) }

      describe 'on an empty tuple' do
        let(:h){ {} }
        it{ should eq({}) }
      end

      describe 'on an valid tuple' do
        let(:h){ {:name => "Alf"} }
        it{ should eq({:name => "Alf"}) }
      end

    end
  end
end

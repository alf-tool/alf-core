require 'spec_helper'
module Alf
  module Types
    describe Tuple, '.coerce' do

      subject{ Tuple.coerce(arg) }

      context 'on a Tuple' do
        let(:arg){ Tuple.new(:name => "bla") }

        it{ should be(arg) }
      end

      context 'on an unsymbolized Hash' do
        let(:arg){ {'name' => "bla"} }

        it{ should eq(Tuple.new(:name => "bla")) }
      end

    end
  end
end
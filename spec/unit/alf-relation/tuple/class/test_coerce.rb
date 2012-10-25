require 'spec_helper'
module Alf
  module Types
    describe Tuple, '.coerce' do

      subject{ Tuple.coerce(arg) }

      let(:expected){ Tuple[name: String].new(:name => "bla") }

      context 'on self' do
        let(:arg){ expected }

        it { should be(expected) }
      end

      context 'on a Tuple' do
        let(:arg){ Tuple[name: String].new(:name => "bla") }

        it{ should eq(expected) }
      end

      context 'on an unsymbolized Hash' do
        let(:arg){ {'name' => "bla"} }

        it{ should eq(expected) }
      end
    end
  end
end

require 'spec_helper'
module Alf
  describe Heading, "coerce" do

    subject{ Heading.coerce(arg) }

    context 'with a Heading' do
      let(:arg){ Heading.new :foo => String }

      it{ should be(arg) }
    end

    context 'with a Hash' do
      let(:arg){ {:foo => String} }

      it{ should eq(Heading.new :foo => String) }
    end

    context 'with an empty Array' do
      let(:arg){ [] }

      it{ should eq(Heading::EMPTY) }
    end

    context 'with a non-empty Array' do
      let(:arg){ ["name", "String"] }

      it{ should eq(Heading.new :name => String) }
    end

    context 'with something unrecognized' do
      let(:arg){ true }

      specify{
        lambda{ subject }.should raise_error(TypeError, /Can't convert `true` into (.*?)Heading/)
      }
    end

  end 
end

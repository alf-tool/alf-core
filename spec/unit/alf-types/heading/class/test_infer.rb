require 'spec_helper'
module Alf
  describe Heading, "infer" do

    subject{ Heading.infer(arg) }

    context 'with a Heading' do
      let(:arg){ Heading.new foo: String }

      it{ should be(arg) }
    end

    context 'with a Hash' do
      let(:arg){ {:foo => 20} }

      it{ should eq(Heading.new foo: Fixnum) }
    end

    context 'with an array of hashes' do
      let(:arg){ [ {foo: 20}, {foo: 12.5} ] }

      it{ should eq(Heading.new foo: Numeric) }
    end

  end 
end

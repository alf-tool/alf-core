require 'spec_helper'
module Alf
  describe Relvar, 'to_relation' do
    include Relvar

    subject{ to_relation }

    let(:expected_value){ Relation(sid: 1, name: "Smith") }

    def to_cog
      [{sid: 1, name: "Smith"}]
    end

    context 'when the heading is supported' do

      def heading(*)
        Heading.new(sid: Integer, name: String)
      end

      it 'trusts the heading' do
        subject.class.heading[:sid].should eq(Integer)
      end

      it 'gets the tuples from the cog' do
        subject.should eq(expected_value)
      end
    end

    context 'when the heading is not supported' do

      def heading(*)
        raise NotSupportedError
      end

      it 'infers the heading' do
        subject.class.heading[:sid].should eq(Fixnum)
      end

      it 'gets the tuples from the cog' do
        subject.should eq(expected_value)
      end
    end

  end
end

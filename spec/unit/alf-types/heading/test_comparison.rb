require 'spec_helper'
module Alf
  describe Heading, "<=>" do

    let(:heading){ Heading.new(name: String, status: Integer, active: Boolean) }

    subject{ heading <=> other }

    context 'with itself' do
      let(:other){ heading }

      before{ heading.should eq(other) }

      it{ should eq(0) }
    end

    context 'with less attributes' do
      let(:other){ Heading.new(name: String) }

      it{ should be_nil }
    end

    context 'with more attributes' do
      let(:other){ Heading.new(name: String, status: Integer, active: Boolean, foo: Date) }

      it{ should be_nil }
    end

    context 'with different attributes' do
      let(:other){ Heading.new(name: String, foo: Date) }

      it{ should be_nil }
    end

    context 'with the same heading' do
      let(:other){ Heading.new(name: String, status: Integer, active: Boolean) }

      before{ heading.should eq(other) }

      it{ should eq(0) }
    end

    context 'with a partial sub heading' do
      let(:other){ Heading.new(name: String, status: Fixnum, active: Boolean) }

      it{ should eq(1) }
    end

    context 'with a full sub heading' do
      let(:other){ Heading.new(name: String, status: Fixnum, active: TrueClass) }

      it{ should eq(1) }
    end

    context 'with a partial super heading' do
      let(:other){ Heading.new(name: String, status: Numeric, active: Boolean) }

      it{ should eq(-1) }
    end

    context 'with a full super heading' do
      let(:other){ Heading.new(name: Object, status: Numeric, active: Object) }

      it{ should eq(-1) }
    end

    context 'with a mixed heading' do
      let(:other){ Heading.new(name: Object, status: Fixnum, active: Boolean) }

      it{ should be_nil }
    end

    context 'when RVAs are present' do
      let(:heading){ Heading.new(prices: Relation[price: Numeric]) }

      context 'with a sub-heading' do
        let(:other){ Heading.new(prices: Relation[price: Float]) }

        it{ should eq(1) }
      end

      context 'with a super-heading' do
        let(:other){ Heading.new(prices: Relation[price: Object]) }

        it{ should eq(-1) }
      end

      context 'with a master heading' do
        let(:other){ Heading.new(prices: Relation) }

        it{ should eq(-1) }
      end
    end

  end
end

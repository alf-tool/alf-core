require 'spec_helper'
module Alf
  describe Relation, '.type for recursive types' do

    shared_examples_for 'the expected recursive type' do
      it{ should be_a(Class) }

      it 'should have correct super class' do
        subject.superclass.should be(Relation)
      end

      it 'should have correct heading' do
        subject.heading.should eq(Heading[name: Integer, children: subject])
      end
    end

    context 'with a hash' do
      subject{
        Relation.type(name: Integer){|r| {children: r} }
      }

      it_should_behave_like 'the expected recursive type'
    end

    context 'with a heading' do
      subject{
        Relation.type(Heading[name: Integer]){|r| {children: r} }
      }

      it_should_behave_like 'the expected recursive type'
    end

    context 'with a tuple type' do
      subject{
        Relation.type(Tuple[name: Integer]){|r| {children: r} }
      }

      it_should_behave_like 'the expected recursive type'
    end

  end
end

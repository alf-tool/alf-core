require 'spec_helper'
module Alf
  module Lang
    describe ObjectOriented, 'tuple_extract' do

      def subject(&bl)
        rel.extend(ObjectOriented.new(rel))
        rel.tuple_extract(&bl)
      end

      context 'on a singleton' do
        let(:rel){ [{:name => "Jones"}] }

        it 'returns the tuple' do
          subject.should eq(:name => "Jones")
        end

        it 'is aliased as tuple!' do
          rel.extend(ObjectOriented.new(rel))
          rel.tuple!.should eq(:name => "Jones")
        end
      end

      context 'on an empty relation' do
        let(:rel){ [] }

        it 'raises a NoSuchTupleError without block' do
          lambda{
            subject
          }.should raise_error(NoSuchTupleError)
        end

        it 'yields if a block' do
          subject{ 12 }.should eq(12)
        end
      end

      context 'on a relation with more than one tuple' do
        let(:rel){ [{:name => "Jones"}, {:name => "Smith"}] }

        it 'raises a NoSuchTupleError' do
          lambda{
            subject
          }.should raise_error(NoSuchTupleError)
        end
      end

    end
  end
end
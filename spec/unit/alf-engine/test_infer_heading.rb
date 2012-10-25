require 'spec_helper'
module Alf
  module Engine
    describe InferHeading do

      subject{ InferHeading.new(input).first }

      context 'on empty input' do
        let(:input){ [] }

        it { should eq({}) }
      end

      context 'with simple tuples' do
        let(:input){
          [
            {tested: 1,    other: "b"},
            {tested: 10.0, other: "a"}
          ]
        }
        let(:expected){
          {tested: Numeric, other: String}
        }

        it{ should eq(expected) }
      end

      context 'with RVAs' do
        let(:input){
          [
            { sid: "S1", supplies: Relation(pid: 10.0) },
            { sid: "S5", supplies: Relation(pid: 12.0) }
          ]
        }
        let(:expected){
          {sid: String, supplies: Relation[pid: Float]}
        }

        it{ should eq(expected) }
      end

      context 'with incompatible RVAs' do
        let(:input){
          [
            { sid: "S1", supplies: Relation(foo: "Bar") },
            { sid: "S5", supplies: Relation(pid: 12.0) }
          ]
        }
        let(:expected){
          {sid: String, supplies: Relation}
        }

        it{ should eq(expected) }
      end

    end
  end # module Engine
end # module Alf

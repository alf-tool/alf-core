require 'spec_helper'
module Alf
  module Engine
    describe InferHeading, 'heading' do

      let(:ih){ InferHeading.new([]) }

      subject{ ih.send(:heading, tuple) }

      context 'on a single tuple' do
        let(:tuple){ {id: 1, name: "Jones"} }

        it{ should eq(Heading.new(id: Fixnum, name: String)) }
      end

      context 'on a tuple with tuple-valued attribute' do
        let(:tuple){ {id: 1, hobby: Tuple(name: "Programming")} }

        it{ should eq(Heading.new(id: Fixnum, hobby: Tuple[name: String])) }
      end

      context 'on a tuple with relation-valued attribute' do
        let(:tuple){ {id: 1, hobby: Relation(name: "Programming")} }

        it{ should eq(Heading.new(id: Fixnum, hobby: Relation[name: String])) }
      end

    end
  end # module Engine
end # module Alf

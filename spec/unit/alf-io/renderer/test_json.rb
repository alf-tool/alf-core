require 'spec_helper'
module Alf
  class Renderer
    describe JSON do

      context 'the class' do
        subject{ JSON }

        it_should_behave_like "a Renderer class"
      end

      context "an instance on a Relation" do
        subject{ JSON.new(input).execute("") }

        let(:input){ Relation(id: [1, 2]) }

        it 'outputs as expected' do
          subject.should eq('[{"id":1},{"id":2}]' << "\n")
        end

        it 'allows roundtripping' do
          Relation(::JSON.parse(subject)).should eq(input)
        end
      end

      context "an instance on a Hash" do
        subject{ JSON.new(input).execute("") }

        let(:input){ {id: 1} }

        it 'outputs as expected' do
          subject.should eq('{"id":1}' << "\n")
        end

        it 'allows roundtripping' do
          ::JSON.parse(subject).should eq({'id' => 1})
        end
      end

    end
  end
end

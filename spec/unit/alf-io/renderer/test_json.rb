require 'spec_helper'
module Alf
  class Renderer
    describe JSON do

      subject{ JSON }

      it_should_behave_like "a Renderer class"

      describe "execute" do
        subject{ JSON.new(input).execute("") }

        let(:input){ Relation(id: [1, 2]) }

        it 'outputs as expected' do
          subject.should eq('[{"id":1},{"id":2}]' << "\n")
        end

        it 'allows roundtripping' do
          Relation(::JSON.parse(subject)).should eq(input)
        end
      end

    end
  end
end

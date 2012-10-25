require 'spec_helper'
module Alf
  class Renderer
    describe YAML do

      subject{ YAML }

      it_should_behave_like "a Renderer class"

      describe "execute" do
        subject{ YAML.new(input).execute("") }

        let(:input){ Relation(id: [1, 2]) }
        let(:expected){
          "---\n" <<
          "- :id: 1\n" <<
          "- :id: 2\n" <<
          "\n"
        }

        it 'outputs as expected' do
          subject.should eq(expected)
        end
      end

    end
  end
end

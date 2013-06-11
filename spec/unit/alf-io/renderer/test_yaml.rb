require 'spec_helper'
module Alf
  class Renderer
    describe YAML do

      subject{ YAML }

      it_should_behave_like "a Renderer class"

      describe "execute" do
        subject{ YAML.new(input).execute("") }

        let(:input){ Relation(id: [1, 2]) }

        it 'outputs as expected' do
          ::YAML.load(subject).should eq([{id: 1}, {id: 2}])
        end
      end

    end
  end
end

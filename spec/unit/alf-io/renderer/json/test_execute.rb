require 'spec_helper'
module Alf
  class Renderer
    describe JSON, 'execute' do

      subject{ JSON.new(input).execute("") }

      let(:input){ Relation[{:id => 1}, {:id => 2}] }

      it 'outputs as expected' do
        subject.should eq('[{"id":1},{"id":2}]')
      end

      it 'allows roundtripping' do
        Relation(::JSON.parse(subject)).should eq(input)
      end

    end
  end
end
  
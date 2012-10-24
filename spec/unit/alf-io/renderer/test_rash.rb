require 'spec_helper'
module Alf
  class Renderer
    describe Rash do

      subject{ Rash.new(input).execute("") }

      let(:input){ Relation[{:id => 1}, {:id => 2}] }

      let(:expected){ "{:id => 1}\n{:id => 2}\n" }

      it 'outputs as expected' do
        subject.should eq(expected)
      end

    end
  end
end

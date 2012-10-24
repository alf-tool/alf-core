require 'spec_helper'
module Alf
  class Renderer
    describe Text do

      subject{ Text.new(input).execute("") }

      let(:input){ Relation[{:id => 1}, {:id => 2}] }

      let(:expected){ "+-----+\n"\
                      "| :id |\n"\
                      "+-----+\n"\
                      "|   1 |\n"\
                      "|   2 |\n"\
                      "+-----+\n"
      }

      it 'outputs as expected' do
        subject.should eq(expected)
      end

    end
  end
end

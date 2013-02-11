require 'spec_helper'
module Alf
  class Renderer
    describe Text do

      context 'the class' do
        subject{ Text }

        it_should_behave_like "a Renderer class"
      end

      describe "execute on a Relation" do
        subject{ Text.new(input).execute("") }

        let(:input){ Relation(id: [1, 2]) }
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

      describe "execute on a Hash" do
        subject{ Text.new(input).execute("") }

        let(:input){ {id: 1} }
        let(:expected){ "+-----+\n"\
                        "| :id |\n"\
                        "+-----+\n"\
                        "|   1 |\n"\
                        "+-----+\n"
        }

        it 'outputs as expected' do
          subject.should eq(expected)
        end
      end

    end
  end
end

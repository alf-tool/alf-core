require 'spec_helper'
module Alf
  class Renderer
    describe Html do

      context 'the class' do
        subject{ Html }

        it_should_behave_like "a Renderer class"
      end

      describe "execute on a Relation" do
        subject{ Html.new(input).execute("") }

        let(:input){ Relation(id: [1, 2]) }
        let(:expected){ "<table>\n"\
                        "  <thead>\n"\
                        "    <tr>\n"\
                        "      <th>id</th>\n"\
                        "    </tr>\n"\
                        "  </thead>\n"\
                        "  <tbody>\n"\
                        "    <tr>\n"\
                        "      <td>1</td>\n"\
                        "    </tr>\n"\
                        "    <tr>\n"\
                        "      <td>2</td>\n"\
                        "    </tr>\n"\
                        "  </tbody>\n"\
                        "</table>\n"
        }

        it 'outputs as expected' do
          subject.should eq(expected.gsub(/\s/,""))
        end
      end

      describe "with subrelations" do
        subject{ Html.new(input).execute("") }

        let(:input){ Relation(sub: Relation(id: [1, 2])) }

        it 'outputs as expected' do
          subject.should match(/<td>\s*<table>/)
        end
      end

    end
  end
end

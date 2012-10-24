require 'spec_helper'
module Alf
  class Renderer
    describe CSV do

      subject{ CSV }

      it_should_behave_like "a Renderer class"

      let(:input){
        [{:id => 1, :name => "Smith"}, {:id => 2, :name => "Jones"}]
      }

      describe "without options" do
        let(:renderer){ CSV.new(input) }
        let(:expected){
          "id,name\n1,Smith\n2,Jones\n"
        }

        subject{ renderer.execute(StringIO.new).string }

        it{ should eq(expected) }
      end

      describe "with options" do
        let(:renderer){ CSV.new(input, options) }
        let(:options){ {col_sep: ";"} }
        let(:expected){
          "id;name\n1;Smith\n2;Jones\n"
        }
        subject{ renderer.execute(StringIO.new).string }

        it{ should eq(expected) }
      end

    end
  end
end
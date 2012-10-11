require 'spec_helper'
module Alf
  describe Viewpoint, "parse" do

    subject{ viewpoint.parse(&expr) }

    context 'on predicate expressions' do
      let(:viewpoint){ Viewpoint }
      let(:expr){ ->{ eq(:x, 2) } }

      it{ should be_a(Predicate) }
    end

    context 'on relational expressions' do
      let(:viewpoint){ Viewpoint }
      let(:expr){ ->{ restrict(:suppliers, ->{ sid == 'S1' }) } }

      it{ should be_a(Algebra::Restrict) }
    end

    context 'on a sub-viewpoint' do
      let(:viewpoint){
        Module.new{
          include Alf::Viewpoint
          def hello; "world"; end
        }
      }
      let(:expr){ ->{ hello } }

      it 'uses the expected binding' do
        subject.should eq("world")
      end
    end

  end
end

require 'spec_helper'
module Alf
  describe Keys, "select" do

    context 'when checking for intersection' do
      subject{ keys.select{|k| (k & [:name]).empty? } }

      let(:keys) {
        Keys[ [:a], [:name], [:last, :name] ]
      }

      let(:expected) {
        Keys[ [:a] ]
      }

      it{ should eq(expected) }
    end

    context 'when taking only empty keys' do
      subject{ keys.select{|k| k.empty?} }

      let(:keys) {
        Keys[ [:a], [], [], [:a, :b] ]
      }

      let(:expected) {
        Keys[ [] ]
      }

      it{ should eq(expected) }
    end

    context 'when checking projections' do
      subject{
        keys.select{|k|
          k.project([:a], false) == k
        }
      }

      context 'when keys are not empty' do
        let(:keys){
          Keys[ [:a], [:a, :name], [] ]
        }

        let(:expected){
          Keys[ [:a], [] ]
        }

        it{ should eq(expected) }
      end

      context 'when keys contains only the empty key' do
        let(:keys){
          Keys[ [] ]
        }

        let(:expected){
          Keys[ [] ]
        }

        it{ should eq(expected) }
      end
    end

  end
end
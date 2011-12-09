require 'spec_helper'
module Alf
  module Engine
    describe Rank::Cesure do

      let(:input) {[
        {:pid => 'P1', :weight => 12.0},
        {:pid => 'P5', :weight => 12.0},
        {:pid => 'P4', :weight => 14.0},
        {:pid => 'P2', :weight => 17.0},
        {:pid => 'P3', :weight => 17.0},
        {:pid => 'P6', :weight => 19.0}
      ]}

      context "when a partial ordering is used" do
        let(:expected) {[
          {:pid => 'P1', :weight => 12.0, :rank => 0},
          {:pid => 'P5', :weight => 12.0, :rank => 0},
          {:pid => 'P4', :weight => 14.0, :rank => 2},
          {:pid => 'P2', :weight => 17.0, :rank => 3},
          {:pid => 'P3', :weight => 17.0, :rank => 3},
          {:pid => 'P6', :weight => 19.0, :rank => 5}
        ]}
        it 'should rank as expected' do
          op = Engine::Rank::Cesure.new(input, AttrList[:weight], :rank)
          op.to_a.should eq(expected.to_a)
        end
      end

      context "when a total ordering is used" do
        let(:expected) {[
          {:pid => 'P1', :weight => 12.0, :rank => 0},
          {:pid => 'P5', :weight => 12.0, :rank => 1},
          {:pid => 'P4', :weight => 14.0, :rank => 2},
          {:pid => 'P2', :weight => 17.0, :rank => 3},
          {:pid => 'P3', :weight => 17.0, :rank => 4},
          {:pid => 'P6', :weight => 19.0, :rank => 5}
        ]}
        it 'should rank as expected' do
          op = Engine::Rank::Cesure.new(input, AttrList[:weight, :pid], :rank)
          op.to_a.should eq(expected.to_a)
        end
      end

    end
  end
end

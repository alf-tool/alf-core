require 'spec_helper'
module Alf
  module Engine
    describe Semi::Hash do

      let(:suppliers) {[
        {:sid => 'S1', :city => 'London'},
        {:sid => 'S2', :city => 'Paris'},
        {:sid => 'S3', :city => 'Paris'}
      ]}

      let(:statuses) {[
        {:sid => 'S1', :status => 20},
        {:sid => 'S3', :status => 30}
      ]}

      context "when used in matching mode" do

        it 'should filter not matching tuples' do
          expected =  [
            {:sid => 'S1', :city => 'London'},
            {:sid => 'S3', :city => 'Paris'}
          ]
          Semi::Hash.new(suppliers, statuses, true).to_a.should eq(expected)
        end

        it 'should return whole operand against DEE' do
          Semi::Hash.new(suppliers, [{}], true).to_a.should eq(suppliers)
        end

        it 'should return an empty operand against DUM' do
          Semi::Hash.new(suppliers, [], true).to_a.should eq([])
        end

      end # matching mode

      context "when used in non matching mode" do

        it 'should filter matching tuples' do
          expected =  [
            {:sid => 'S2', :city => 'Paris'},
          ]
          Semi::Hash.new(suppliers, statuses, false).to_a.should eq(expected)
        end

        it 'should return whole operand against DUM' do
          Semi::Hash.new(suppliers, [], false).to_a.should eq(suppliers)
        end

        it 'should return an empty operand against DEE' do
          Semi::Hash.new(suppliers, [{}], false).to_a.should eq([])
        end

      end # non matching mode

    end
  end # module Engine
end # module Alf

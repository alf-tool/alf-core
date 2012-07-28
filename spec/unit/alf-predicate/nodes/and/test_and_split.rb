require 'spec_helper'
module Alf
  class Predicate
    describe And, "and_split" do

      let(:tautology){ Factory.tautology  }

      subject{ predicate.and_split(list) }

      context 'when attributes on one side' do
        let(:predicate){ Factory.eq(:x, 2) & Factory.eq(:y, 3) }

        context 'when fully covered' do
          let(:list){ AttrList[:x, :y] }

          it{ should eq([predicate, tautology]) }
        end

        context 'when not covered at all' do
          let(:list){ AttrList[:name] }

          it{ should eq([tautology, predicate]) }
        end

        context 'when partially covered' do
          let(:list){ AttrList[:x] }

          it{ should eq([Factory.eq(:x, 2), Factory.eq(:y, 3)]) }
        end
      end

      context 'when attributes on both sides' do
        let(:predicate){ Factory.eq(:x, 2) & Factory.eq(:y, :z) }

        context 'when fully covered' do
          let(:list){ AttrList[:x, :y, :z] }

          it{ should eq([predicate, tautology]) }
        end

        context 'when not covered at all' do
          let(:list){ AttrList[:name] }

          it{ should eq([tautology, predicate]) }
        end

        context 'when partially covered but split-able' do
          let(:list){ AttrList[:x] }

          it{ should eq([Factory.eq(:x, 2), Factory.eq(:y, :z)]) }
        end

        context 'when partially covered but split-able (2)' do
          let(:list){ AttrList[:y] }

          it{ should eq([Factory.eq(:y, :z), Factory.eq(:x, 2)]) }
        end

        context 'when partially covered but not split-able' do
          let(:list){ AttrList[:x, :y] }

          it{ should eq([predicate, tautology]) }
        end
      end

    end
  end
end
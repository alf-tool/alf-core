require 'spec_helper'
module Alf
  module Engine
    describe Ungroup do

      let(:input){[
        {:city => "London", :suppliers => [
                              {:name => "Smith"},
                              {:name => "Blake"}
                            ]},
        {:city => "Paris", :suppliers => [
                              {:name => "Jones"}
                            ]},
      ]}

      let(:expected){[
        {:name => "Smith", :city => "London"},
        {:name => "Blake", :city => "London"},
        {:name => "Jones", :city => "Paris"},
      ]}

      it 'should ungroup specified attribute' do
        Ungroup.new(input, :suppliers).to_a.should eq(expected)
      end

    end
  end # module Engine
end # module Alf

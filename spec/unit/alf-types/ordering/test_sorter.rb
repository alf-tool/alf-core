require 'spec_helper'
module Alf
  describe Ordering, "sorter" do

    let(:sorter){ Ordering.coerce([[:a, :desc]]).sorter }

    it 'should sort correctly' do
      [{:a => 2}, 
       {:a => 7}, 
       {:a => 1}].sort(&sorter).should eq([
         {:a => 7}, {:a => 2}, {:a => 1}
      ])
    end

  end # Ordering
end # Alf

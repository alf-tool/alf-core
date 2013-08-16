require 'spec_helper'
module Alf
  describe "Relation#to_hash" do

    let(:rel){
      Alf::Relation([
        {sid: 'S1', name: 'Jones', city: 'London', status: 20},
        {sid: 'S2', name: 'Blake', city: 'London', status: 20},
      ])
    }

    specify "with :sid => :name" do
      rel.to_hash(:sid => :name).should eq('S1' => 'Jones', 'S2' => 'Blake')
    end

    specify "with :sid => :city" do
      rel.to_hash(:sid => :city).should eq('S1' => 'London', 'S2' => 'London')
    end

    specify "with :city => :sid" do
      lambda{
        rel.to_hash(:city => :sid)
      }.should raise_error(/Key expected for `city`, divergence found on `London`/)
    end

    specify "with :city => :status" do
      rel.to_hash(:city => :status).should eq('London' => 20)
    end

  end
end
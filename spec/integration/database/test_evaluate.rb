require 'spec_helper'
module Alf
  describe Database, "evaluate" do

    let(:db){ examples_database }

    it 'should recognize Relation literals' do
      db.evaluate {
        Relation(
          Tuple(:pid => 'P1', :name => 'Nut',   :color => 'red',   :heavy => true ),
          Tuple(:pid => 'P2', :name => 'Bolt',  :color => 'green', :heavy => false),
          Tuple(:pid => 'P3', :name => 'Screw', :color => 'blue',  :heavy => false)
        )
      }.should be_a(Relation)
    end

    it "recognizes Tuple literals" do
      db.evaluate{
        Tuple(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
      }.should eq(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
    end

    it 'recognize aggregators' do
      db.evaluate{
        sum{ qty }
      }.should be_a(Aggregator)
    end

    it 'resolves DUM and DEE constants' do
      db.evaluate{ DUM }.should be_a(Relation)
      db.evaluate{ DEE }.should be_a(Relation)
      db.evaluate('DUM').should be_a(Relation)
      db.evaluate('DEE').should be_a(Relation)
    end

  end
end

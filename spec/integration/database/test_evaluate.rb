require 'spec_helper'
describe Alf::Database, "evaluate" do

  let(:db){ examples_database }

  it 'should recognize Relation literals' do
    db.evaluate {
      Relation(
        Tuple(:pid => 'P1', :name => 'Nut',   :color => 'red',   :heavy => true ),
        Tuple(:pid => 'P2', :name => 'Bolt',  :color => 'green', :heavy => false),
        Tuple(:pid => 'P3', :name => 'Screw', :color => 'blue',  :heavy => false)
      )
    }.should be_a(Alf::Relation)
  end

  it "recognizes Tuple literals" do
    db.evaluate{
      Tuple(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
    }.should eq(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
  end

  it 'recognize aggregators' do
    db.evaluate{
      sum{ qty }
    }.should be_a(Alf::Aggregator)
  end

  it 'resolves DUM and DEE constants' do
    db.evaluate{ DUM }.should be_a(Alf::Relation)
    db.evaluate{ DEE }.should be_a(Alf::Relation)
    db.evaluate('DUM').should be_a(Alf::Relation)
    db.evaluate('DEE').should be_a(Alf::Relation)
  end

end
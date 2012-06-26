require 'spec_helper'
describe Alf::Connection, "evaluate" do

  let(:conn){ examples_database }

  it 'should recognize Relation literals' do
    conn.evaluate {
      Relation(
        Tuple(:pid => 'P1', :name => 'Nut',   :color => 'red',   :heavy => true ),
        Tuple(:pid => 'P2', :name => 'Bolt',  :color => 'green', :heavy => false),
        Tuple(:pid => 'P3', :name => 'Screw', :color => 'blue',  :heavy => false)
      )
    }.should be_a(Alf::Relation)
  end

  it "recognizes Tuple literals" do
    conn.evaluate{
      Tuple(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
    }.should eq(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
  end

  it 'recognize aggregators' do
    conn.evaluate{
      sum{ qty }
    }.should be_a(Alf::Aggregator)
  end

  it 'resolves DUM and DEE constants' do
    conn.evaluate{ DUM }.should be_a(Alf::Relation)
    conn.evaluate{ DEE }.should be_a(Alf::Relation)
    conn.evaluate('DUM').should be_a(Alf::Relation)
    conn.evaluate('DEE').should be_a(Alf::Relation)
  end

end
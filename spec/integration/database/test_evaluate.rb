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


  end
end

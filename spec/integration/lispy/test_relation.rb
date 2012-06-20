require 'spec_helper'
module Alf
  describe Lispy, "Relation(...)" do

    let(:lispy){ Alf.lispy(Environment.examples) }

    subject{ lispy.Relation(*args) }

    describe 'on a single tuple' do
      let(:args){ [{:name => "Alf"}] }
      it{ should eq(Relation[*args]) }
    end

    describe 'on two tuples' do
      let(:args){ [{:name => "Alf"}, {:name => "Lispy"}] }
      it{ should eq(Relation[*args]) }
    end

    describe 'on a Symbol' do
      let(:args){ [:suppliers] }
      specify{ 
        subject.should eq(lispy.environment.dataset(:suppliers).to_rel) 
      }
    end

    describe "on the documentation example" do
      specify {
        lispy.evaluate{
          Relation(
            Tuple(:pid => 'P1', :name => 'Nut',   :color => 'red',   :heavy => true ),
            Tuple(:pid => 'P2', :name => 'Bolt',  :color => 'green', :heavy => false),
            Tuple(:pid => 'P3', :name => 'Screw', :color => 'blue',  :heavy => false)
          )      
        }.should be_a(Relation)
      }
    end

  end
end

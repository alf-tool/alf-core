require 'spec_helper'
module Alf
  module Engine
    describe Join::Hash do

      let(:suppliers) {[
        {:sid => 'S1', :city => 'London'},
        {:sid => 'S2', :city => 'Paris'},
        {:sid => 'S3', :city => 'Paris'}
      ]}

      let(:statuses) {[
        {:sid => 'S1', :status => 20},
        {:sid => 'S2', :status => 10},
        {:sid => 'S3', :status => 30}
      ]}

      let(:countries) {[
        {:city => 'London',    :country => 'England'},
        {:city => 'Paris',     :country => 'France'},
        {:city => 'Bruxelles', :country => 'Belgium'}
      ]}

      context "when applied on candidate keys on both sides" do
        subject{ Join::Hash.new(suppliers, statuses).to_a }
        let(:expected){[
          {:sid => 'S1', :city => 'London', :status => 20},
          {:sid => 'S2', :city => 'Paris', :status => 10},
          {:sid => 'S3', :city => 'Paris', :status => 30}
        ]}
        it { should == expected }
      end

      context "when applied on a typical foreign key" do
        subject{ Join::Hash.new(suppliers, countries).to_a }
        let(:expected){[
          {:sid => 'S1', :city => 'London', :country => 'England'},
          {:sid => 'S2', :city => 'Paris',  :country => 'France'},
          {:sid => 'S3', :city => 'Paris',  :country => 'France'}
        ]}
        it { should == expected }
      end

      context "when applied with no attributes in common" do
        subject{ Join::Hash.new(statuses, countries).to_a }
        let(:expected){
          statuses.collect{|s| countries.collect{|c| c.merge(s)}}.flatten
        }
        it { should == expected }
      end

    end
  end # module Engine
end # module Alf    


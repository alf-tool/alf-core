require 'spec_helper'
module Alf
  module Operator::Relational
    describe Matching::HashBased do
        
      let(:suppliers) {Alf::Relation[
        {:sid => 'S1', :city => 'London'},
        {:sid => 'S2', :city => 'Paris'},
        {:sid => 'S3', :city => 'Paris'}
      ]}
  
      let(:statuses) {Alf::Relation[
        {:sid => 'S1', :status => 20},
        {:sid => 'S2', :status => 10},
        {:sid => 'S3', :status => 30}
      ]}
  
      let(:countries) {Alf::Relation[
        {:city => 'London',    :country => 'England'},
        {:city => 'Paris',     :country => 'France'},
        {:city => 'Bruxelles', :country => 'Belgium (until ?)'}
      ]}
  
      let(:operator){ Matching::HashBased.new }
      subject{ operator.to_rel }
  
      describe "when applied on both candidate keys" do
        before{ operator.pipe  [suppliers, statuses] }
        it { should eq(suppliers) }
      end
      
      describe "when applied on a typical foreign key" do
        describe "on one way" do
          before{ operator.pipe  [suppliers, countries] }
          it { should eq(suppliers) }
        end
        describe "on the other way around" do
          before{ operator.pipe  [countries, suppliers] }
          it { should eq(countries.restrict(lambda{ city != 'Bruxelles' })) }
        end
      end
      
      describe "when no attributes are in common" do
        before{ operator.pipe  [statuses, countries] }
        it { should eq(statuses) }
      end
      
      describe "against DEE" do
        before{ operator.pipe  [suppliers, Relation::DEE] }
        it { should eq(suppliers) }
      end
      
      describe "against DUM" do
        before{ operator.pipe  [suppliers, Relation::DUM] }
        it { should eq(Relation::DUM) }
      end

    end 
  end
end
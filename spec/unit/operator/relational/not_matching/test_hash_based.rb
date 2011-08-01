require 'spec_helper'
module Alf
  module Operator::Relational
    describe NotMatching::HashBased do
        
      let(:suppliers) {Alf::Relation[
        {:sid => 'S1', :city => 'London'},
        {:sid => 'S2', :city => 'Paris'},
        {:sid => 'S3', :city => 'Paris'}
      ]}
  
      let(:operator){ NotMatching::HashBased.new }
      subject{ operator.to_rel }

      describe "when applied on itself" do
        before{ operator.pipe [suppliers, suppliers] }
        it { should eq(suppliers.minus(suppliers)) }
      end
  
      describe "when applied against a subset" do
        before{ operator.pipe [suppliers, Alf::Relation[{:sid => 'S1'}]] }
        it { should eq(suppliers.restrict(lambda{ sid != 'S1' })) }
      end
      
      describe "against DEE" do
        before{ operator.pipe [suppliers, Relation::DEE] }
        it { should eq(Relation::DUM) }
      end
      
      describe "against DUM" do
        before{ operator.pipe [suppliers, Relation::DUM] }
        it { should eq(suppliers) }
      end

    end 
  end
end
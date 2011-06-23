require 'spec_helper'
module Alf
  module Operator::Relational
    describe Join do
        
      let(:suppliers){Relation.coerce [
        {:sid => 'S1', :city => 'London'},
        {:sid => 'S2', :city => 'Paris'},
        {:sid => 'S3', :city => 'Paris'},
        {:sid => 'S4', :city => 'London'},
        {:sid => 'S5', :city => 'Athens'},
      ]} 
      
      describe "when applied to sub-relations" do
        let(:suppliers_by_city){Relation.coerce( 
          Lispy.group(suppliers, [:sid], :suppliers)
        )}
        let(:s2_s3){Relation.coerce([
          {:sid => 'S3'},
          {:sid => 'S2'}
        ])} 
        let(:right){Relation.coerce([
          {:suppliers => s2_s3, :hello => "world"}
        ])}
        let(:expected){Relation.coerce([
          {:suppliers => s2_s3, :hello => "world", :city => 'Paris'}
        ])}
        subject{Relation.coerce(
          Lispy.join(suppliers_by_city, right)
        )}
        it{ should == expected }
      end
      
    end
  end
end
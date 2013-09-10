require 'spec_helper'
describe Alf::Relation, 'to_array' do

  let(:rel) {
    examples_database.query do
      group((project suppliers, [:city, :name]), [:name], :incity)
    end
  }

  let(:expected){
    [
      Tuple(:city => 'Athens', :incity => [ Tuple(:name => 'Adams') ] ),
      Tuple(:city => 'London', :incity => [ Tuple(:name => 'Clark'), Tuple(:name => 'Smith') ]),
      Tuple(:city => 'Paris',  :incity => [ Tuple(:name => 'Blake'), Tuple(:name => 'Jones') ]),
    ]
  }

  let(:ordering){ [:city, [:incity, :name]] }

  it 'recursively converts to sorted arrays' do
    rel.to_array(:sort => ordering).should eq(expected)
  end

  # it 'is aliased as to_a' do
  #   rel.to_a(:sort => ordering).should eq(expected)
  # end

end
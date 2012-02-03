require 'spec_helper'
describe "Relation()" do

  it 'returns a Relation' do
    Relation(:name => "Alf").should be_a(Alf::Relation)
  end

  it 'helps building a singleton' do
    Relation(:name => "Alf").cardinality.should eq(1)
  end

  it 'helps building a list if values' do
    Relation(:name => ["Alf", "Myrrha"]).cardinality.should eq(2)
  end

end

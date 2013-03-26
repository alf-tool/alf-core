require 'spec_helper'
describe Alf::Algebra, 'to_dot' do

  let(:rel) {
    examples_database.parse do
      group((project suppliers, [:city, :name]), [:name], :incity, allbut: true)
    end
  }

  it 'recursively converts to sorted arrays' do
    rel.to_dot.should =~ /digraph/
  end

end

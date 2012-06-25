require 'spec_helper'
describe Alf::Database, "compile" do

  let(:db){ examples_database }

  it 'returns evaluated expression' do
    db.compile{
      (restrict :suppliers, lambda{ status > 10 })
    }.should be_a(Alf::Operator::Relational::Restrict)
  end

  it 'should binds operators correctly' do
    restriction = db.compile{
      (restrict (project :suppliers, [:status]), lambda{ status > 10 })
    }
    restriction.context.should eq(db)
    restriction.operand.context.should eq(db)
  end

end

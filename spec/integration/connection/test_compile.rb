require 'spec_helper'
describe Alf::Connection, "compile" do

  let(:conn){ examples_database }

  it 'returns evaluated expression' do
    conn.compile{
      (restrict :suppliers, lambda{ status > 10 })
    }.should be_a(Alf::Operator::Relational::Restrict)
  end

  it 'should binds operators correctly' do
    restriction = conn.compile{
      (restrict (project :suppliers, [:status]), lambda{ status > 10 })
    }
    restriction.context.should eq(conn)
    restriction.operand.context.should eq(conn)
  end

end

require 'spec_helper'
describe Alf::Connection, "compile" do

  let(:conn){ examples_database }

  it 'returns evaluated expression' do
    conn.parse{
      (restrict :suppliers, lambda{ status > 10 })
    }.should be_a(Alf::Operator::Relational::Restrict)
  end

  it 'should binds operators correctly' do
    restriction = conn.parse{
      (restrict (project :suppliers, [:status]), lambda{ status > 10 })
    }
    restriction.context.should eq(conn)
    restriction.operand.context.should eq(conn)
  end

  it "uses a clean binding" do
    p = conn.parse("lambda{ path }", "a path")
    lambda{ p.call }.should raise_error(NameError)
  end

  it "should resolve __FILE__ correctly" do
    p = conn.parse("__FILE__", "a path")
    p.should == "a path"
  end

end

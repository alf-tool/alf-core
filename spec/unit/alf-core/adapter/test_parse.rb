require 'spec_helper'
module Alf
  describe Adapter, "parse" do

    let(:conn){ examples_database }

    it 'returns evaluated expression' do
      conn.parse{
        (restrict :suppliers, lambda{ status > 10 })
      }.should be_a(Operator::Relational::Restrict)
    end

    it 'binds operators correctly' do
      restriction = conn.parse{
        (restrict (project :suppliers, [:status]), lambda{ status > 10 })
      }
      restriction.context.should eq(conn)
      restriction.operand.context.should eq(conn)
    end

    it 'returns VarRef on a Symbol' do
      var_ref = conn.parse(:suppliers)
      var_ref.should be_a(Operator::VarRef)
      var_ref.name.should eq(:suppliers)
      var_ref.context.should eq(conn)
    end

    it 'converts Symbols to VarRef (block form)' do
      conn.parse{ :suppliers }.should be_a(Operator::VarRef)
    end

    it 'converts symbol operands to VarRef instances' do
      expr = conn.parse{ project(:suppliers, [:sid]) }
      op   = expr.operand
      op.should be_a(Operator::VarRef)
      op.name.should eq(:suppliers)
      op.context.should eq(conn)
    end

    it "uses a clean binding" do
      p = conn.parse("lambda{ path }", "a path")
      lambda{ p.call }.should raise_error(NameError)
    end

    it "resolves __FILE__ correctly" do
      p = conn.parse("__FILE__", "a path")
      p.should == "a path"
    end

  end
end

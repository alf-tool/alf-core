require 'spec_helper'
module Alf
  describe Database, "compile" do

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
      restriction.database.should eq(db)
      restriction.operand.database.should eq(db)
    end

  end
end

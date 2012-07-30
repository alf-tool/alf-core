require 'spec_helper'
module Alf
  class Database
    describe Schema, "parse" do

      let(:dbdef) { Class.new(Database){ relvar :suppliers } }
      let(:db)    { dbdef.new(Connection.folder '.')         }
      let(:schema){ db.default_schema                        }

      it 'returns evaluated expression' do
        schema.parse{
          (restrict suppliers, lambda{ status > 10 })
        }.should be_a(Operator::Relational::Restrict)
      end

      it 'returns resolves relvars correctly' do
        schema.parse{
          (restrict suppliers, lambda{ status > 10 })
        }.operand.should be_a(Operator::VarRef)
      end

      it 'binds operators correctly' do
        restriction = schema.parse{
          (restrict (project :suppliers, [:status]), lambda{ status > 10 })
        }
        restriction.context.should be(db.connection)
        restriction.operand.context.should be(db.connection)
      end

    end
  end
end

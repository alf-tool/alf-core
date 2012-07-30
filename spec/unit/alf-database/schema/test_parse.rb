require 'spec_helper'
module Alf
  class Database
    describe Schema, "parse" do

      let(:dbdef) { Class.new(Database){ relvar :suppliers } }
      let(:db)    { dbdef.new(Connection.folder '.')         }
      let(:schema){ db.default_schema                        }

      subject{
        schema.parse{
          (restrict suppliers, lambda{ status > 10 })
        }
      }

      it 'returns evaluated expression' do
        subject.should be_a(Operator::Relational::Restrict)
      end

      it 'returns resolves relvars correctly' do
        subject.operand.should be_a(Operator::VarRef)
      end

      it 'binds operators correctly' do
        subject.operand.context.should eq(db)
      end

    end
  end
end

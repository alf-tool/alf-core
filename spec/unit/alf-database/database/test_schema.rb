require 'spec_helper'
module Alf
  describe Database, 'schema' do

    let(:db){ Database.new(Connection.folder('.')) }

    context 'on unexisting schema' do
      subject{ db.schema(:unexisting) }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error(NoSuchSchemaError)
      end
    end

    context 'on the native schema' do
      subject{ db.schema(:native) }

      it{ should be_a(Database::Schema) }

      it 'binds the schema correctly' do
        subject.database.should be(db)
        subject.definition.should be_a(Database::SchemaDef)
      end
    end

  end
end
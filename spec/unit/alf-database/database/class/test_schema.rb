require 'spec_helper'
module Alf
  describe Database, '.schema' do

    let(:db_class){ Class.new(Database) }

    let(:existing){ db_class.schema(:existing){} }

    context 'when the schema does not exists and no block is given' do
      subject{ db_class.schema(:public) }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error(NoSuchSchemaError)
      end
    end

    context 'when the schema does not exists yet but a bock is given' do
      subject{ db_class.schema(:public){ relvar :suppliers } }

      after do
        lambda{
          subject.instance_method(:suppliers)
        }.should_not raise_error(NameError)
      end

      it{ should be_a(Database::SchemaDef) }
    end

    context 'when the schema already exists and no block is given' do
      subject{ db_class.schema(:existing) }
      before{ existing }

      it{ should be(existing) }
    end

    context 'when the schema already exists and a block is given' do
      subject{ db_class.schema(:existing){ relvar :suppliers } }
      before{ existing }

      after do
        lambda{
          subject.instance_method(:suppliers)
        }.should_not raise_error(NameError)
      end

      it{ should be(existing) }
    end

  end
end
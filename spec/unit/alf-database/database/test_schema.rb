require 'spec_helper'
module Alf
  describe Database, '.schema' do

    shared_examples_for 'the #schema method' do

      let(:db_class){ Class.new(Database) }

      let(:existing){ db_class.schema(:existing) }

      def schema(name, defn)
        defn ? db_class.schema(name, &defn) : db_class.schema(name)
      end

      context 'when the schema does not exists yet' do
        subject{ schema(:public, defn) }

        it{ should be_a(Database::Schema) }
      end

      context 'when the schema already exists' do
        subject{ schema(:existing, defn) }
        before{ existing }

        it{ should be(existing) }
      end
    end

    context 'without block' do
      let(:defn){ nil }

      it_should_behave_like 'the #schema method'
    end

    context 'with a block' do

      after do
        lambda{
          subject.instance_method(:suppliers)
        }.should_not raise_error(NameError)
      end

      let(:defn){ lambda{ relvar :suppliers } }

      it_should_behave_like 'the #schema method'
    end

  end
end
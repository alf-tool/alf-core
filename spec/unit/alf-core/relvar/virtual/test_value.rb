require 'spec_helper'
module Alf
  class Relvar
    describe Virtual, 'value' do

      let(:database) {
        examples_database
      }
      let(:expression) {
        database.parse{ project(suppliers, [:sid]) }
      }
      let(:relvar){
        Virtual.new(database.connection, nil, expression)
      }

      subject{ relvar.value }

      it 'returns a Relation value' do
        subject.should be_a(Relation)
      end

    end
  end
end
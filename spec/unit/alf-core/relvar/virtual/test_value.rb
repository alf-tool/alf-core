require 'spec_helper'
module Alf
  class Relvar
    describe Virtual, 'value' do

      let(:database) { 
        examples_database 
      }
      let(:expression) { 
        database.compile{ project(:suppliers, [:sid]) }
      }
      let(:relvar){ 
        Virtual.new(database, nil, expression) 
      }

      subject{ relvar.value }

      it 'returns a Relation value' do
        subject.should be_a(Relation)
      end

    end
  end
end
require 'spec_helper'
module Alf
  class Relvar
    describe Base, 'value' do

      let(:database){ examples_database       }
      let(:name)    { :suppliers              }
      let(:relvar)  { Base.new(database,name) }

      subject{ relvar.value }

      it 'returns a Relation value' do
        subject.should be_a(Relation)
      end

    end
  end
end
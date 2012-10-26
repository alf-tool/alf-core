require 'spec_helper'
module Alf
  describe Relvar, 'type_safe' do

    let(:operand){ an_operand.with_heading(status: Integer)     }
    let(:relvar) { operand.to_relvar.type_safe(status: Integer) }

    context 'when invalid tuples are inserted' do
      let(:tuples){
        [ {status: "blah"} ]
      }
      subject{ relvar.insert(tuples) }

      it 'raises a TypeCheckError' do
        lambda{
          subject
        }.should raise_error(TypeCheckError)
      end
    end

  end
end
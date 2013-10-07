require 'type_check_helper'
module Alf
  module Algebra
    describe Minus, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          minus(suppliers, suppliers)
        }

        it{ should eq(op.heading) }
      end

      context 'when heading mismatch' do
        let(:op){ 
          minus(suppliers, supplies)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /heading mismatch/)
        end
      end

    end
  end
end

require 'type_check_helper'
module Alf
  module Algebra
    describe Coerce, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          coerce(suppliers, sid: Float)
        }

        it{ should eq(op.heading) }
      end

      context 'when unexisting attribute' do
        let(:op){ 
          coerce(suppliers, sid: Float, unknown: String)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `unknown`/)
        end
      end

      context 'when unexisting attributes' do
        let(:op){ 
          coerce(suppliers, sid: Float, foo: String, bar: String)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attributes `foo`,`bar`/)
        end
      end

    end
  end
end

require 'type_check_helper'
module Alf
  module Algebra
    describe Restrict, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          restrict(suppliers, city: 'London')
        }

        it{ should eq(op.heading) }
      end

      context 'when no such attribute' do
        let(:op){ 
          restrict(suppliers, foo: 'London')
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `foo`/)
        end
      end

      context 'when no such attribute (complex expression)' do
        let(:pred){
          pred = Predicate.eq(city: "London")
          pred = pred | (Predicate.neq(foo: "Paris") & Predicate.neq(bar: "Paris"))
        }
        let(:op){ 
          restrict(suppliers, pred)
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

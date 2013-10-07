require 'type_check_helper'
module Alf
  module Algebra
    describe Extend, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          extend(suppliers, foo: 12)
        }

        it{ should eq(op.heading) }
      end

      context 'when clash attribute' do
        let(:op){ 
          extend(suppliers, sid: ->{}, foo: 12)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /cannot override `sid`/)
        end
      end

      context 'when unexisting attributes' do
        let(:op){ 
          extend(suppliers, sid: ->{}, name: ->{}, bar: String)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /cannot override `sid`,`name`/)
        end
      end

    end
  end
end

require 'type_check_helper'
module Alf
  module Algebra
    describe Rename, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          rename(suppliers, name: :sname)
        }

        it{ should eq(op.heading) }
      end

      context 'when invalid renaming' do
        let(:op){ 
          rename(suppliers, foo: :bar)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `foo`/)
        end
      end

      context 'when name clash' do
        let(:op){ 
          rename(suppliers, name: :sid)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /cannot override `sid`/)
        end
      end

    end
  end
end

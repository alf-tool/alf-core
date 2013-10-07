require 'type_check_helper'
module Alf
  module Algebra
    describe Sort, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          sort(suppliers, [:name, :asc])
        }

        it{ should eq(op.heading) }
      end

      context 'when no such attribute' do
        let(:op){ 
          sort(suppliers, [:foo, :asc])
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `foo`/)
        end
      end

    end
  end
end

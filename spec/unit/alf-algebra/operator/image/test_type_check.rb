require 'type_check_helper'
module Alf
  module Algebra
    describe Image, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          image(suppliers, supplies, :supplying)
        }

        it{ should eq(op.heading) }
      end

      context 'when diasllowed overriding' do
        let(:op){ 
          image(suppliers, supplies, :sid)
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

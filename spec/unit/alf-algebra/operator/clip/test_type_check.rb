require 'type_check_helper'
module Alf
  module Algebra
    describe Clip, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          clip(suppliers, [:sid, :name])
        }

        it{ should eq(op.heading) }
      end

      context 'when clipping unexisting attribute' do
        let(:op){ 
          clip(suppliers, [:sid, :unknown])
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `unknown`/)
        end
      end

      context 'when clipping unexisting attributes' do
        let(:op){ 
          clip(suppliers, [:sid, :foo, :bar])
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

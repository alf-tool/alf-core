require 'type_check_helper'
module Alf
  module Algebra
    describe Project, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          project(suppliers, [:sid, :name])
        }

        it{ should eq(op.heading) }
      end

      context 'when projectping unexisting attribute' do
        let(:op){ 
          project(suppliers, [:sid, :unknown])
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `unknown`/)
        end
      end

      context 'when projectping unexisting attributes' do
        let(:op){ 
          project(suppliers, [:sid, :foo, :bar])
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

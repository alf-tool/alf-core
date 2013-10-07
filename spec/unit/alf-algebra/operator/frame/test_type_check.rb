require 'type_check_helper'
module Alf
  module Algebra
    describe Frame, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          frame(suppliers, [], 2, 4)
        }

        it{ should eq(op.heading) }
      end

      context 'when invalid ordering' do
        let(:op){ 
          frame(suppliers, [[:sid, :asc], [:foo, :asc], [:bar, :asc]], 2, 4)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attributes `foo`,`bar`/)
        end
      end

      context 'when negative offset' do
        let(:op){ 
          frame(suppliers, [[:sid, :asc]], -2, 4)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /invalid offset `-2`/)
        end
      end

      context 'when negative limit' do
        let(:op){ 
          frame(suppliers, [[:sid, :asc]], 2, -4)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /invalid limit `-4`/)
        end
      end

    end
  end
end

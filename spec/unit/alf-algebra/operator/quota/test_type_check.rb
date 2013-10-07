require 'type_check_helper'
module Alf
  module Algebra
    describe Quota, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          quota(supplies, [:sid], [[:sid, :asc]], :sum => sum{ qty })
        }

        it{ should eq(op.heading) }
      end

      context 'when unknown by' do
        let(:op){ 
          quota(supplies, [:foo], [[:sid, :asc]], :sum => sum{ qty })
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `foo`/)
        end
      end

      context 'when invalid ordering' do
        let(:op){ 
          quota(supplies, [:sid], [[:bar, :asc]], :sum => sum{ qty })
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `bar`/)
        end
      end

      context 'when name clash' do
        let(:op){ 
          quota(supplies, [:sid], [[:sid, :asc]], :qty => sum{ qty })
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /cannot override `qty`/)
        end
      end

    end
  end
end

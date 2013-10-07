require 'type_check_helper'
module Alf
  module Algebra
    describe Hierarchize, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          hierarchize(supplies, [:sid], [:pid], :children)
        }

        it{ should eq(op.heading) }
      end

      context 'when no such attribute on identifier' do
        let(:op){ 
          hierarchize(supplies, [:foo], [:pid], :children)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `foo`/)
        end
      end

      context 'when no such attribute on mapping children' do
        let(:op){ 
          hierarchize(supplies, [:sid], [:bar], :children)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `bar`/)
        end
      end

      context 'when diasllowed overriding' do
        let(:op){ 
          hierarchize(supplies, [:sid], [:pid], :qty)
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

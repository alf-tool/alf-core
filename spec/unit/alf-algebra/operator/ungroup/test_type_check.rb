require 'type_check_helper'
module Alf
  module Algebra
    describe Ungroup, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          ungroup(group(suppliers, [:status, :city], :extra), :extra)
        }

        it{ should eq(op.heading) }
      end

      context 'when not a grouped attribute' do
        let(:op){ 
          ungroup(suppliers, :sid)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /not a relation-valued attribute `sid`/)
        end
      end

      context 'when name clash resulting' do
        let(:op){ 
          inside = group(suppliers, [:status, :city], :extra)
          inside = rename(inside, :sid => :city)
          ungroup(inside, :extra)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /cannot override `city`/)
        end
      end

    end
  end
end

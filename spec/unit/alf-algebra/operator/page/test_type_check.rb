require 'type_check_helper'
module Alf
  module Algebra
    describe Page, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          page(suppliers, [], 1, page_size: 12)
        }

        it{ should eq(op.heading) }
      end

      context 'when negative page index' do
        let(:op){ 
          page(suppliers, [], -1, page_size: 12)
        }

        it{ should eq(op.heading) }
      end

      context 'when invalid ordering' do
        let(:op){ 
          page(suppliers, [[:sid, :asc], [:foo, :asc], [:bar, :asc]], 2)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attributes `foo`,`bar`/)
        end
      end

      context 'when negative page_size' do
        let(:op){ 
          page(suppliers, [[:sid, :asc]], 2, page_size: -4)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /invalid page size `-4`/)
        end
      end

    end
  end
end

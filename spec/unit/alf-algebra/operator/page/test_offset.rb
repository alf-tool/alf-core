require 'spec_helper'
module Alf
  module Algebra
    describe Page, 'offset' do

      subject{ op.offset }

      let(:operand){
        an_operand.with_heading(id: Fixnum)
      }

      context 'with the first page' do
        let(:op){
          a_lispy.page(operand, [[:id, :desc]], 1)
        }

        it { should eq(0) }
      end

      context 'with the second page' do
        let(:op){
          a_lispy.page(operand, [[:id, :desc]], 2)
        }

        it { should eq(30) }
      end

      context 'with the second page and explicit page size' do
        let(:op){
          a_lispy.page(operand, [[:id, :desc]], 3, page_size: 23)
        }

        it { should eq(46) }
      end

    end
  end
end

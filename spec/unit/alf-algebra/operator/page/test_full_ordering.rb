require 'spec_helper'
module Alf
  module Algebra
    describe Page, 'full_ordering' do

      subject{ op.full_ordering }

      context 'when the initial ordering covers a key' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id])
        }
        let(:op){
          a_lispy.page(operand, [[:id, :desc]], 1)
        }
        let(:expected){
          Ordering.new([[:id, :desc]])
        }

        it { should eq(expected) }
      end

      context 'when the initial ordering does not cover a key' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id, :name])
        }
        let(:op){
          a_lispy.page(operand, [[:name, :desc]], 1)
        }
        let(:expected){
          Ordering.new([[:name, :desc], [:id, :asc]])
        }

        it { should eq(expected) }
      end

      context 'when no key' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String)
        }
        let(:op){
          a_lispy.page(operand, [[:name, :desc]], 1)
        }
        let(:expected){
          Ordering.new([[:name, :desc], [:id, :asc]])
        }

        it { should eq(expected) }
      end

    end
  end
end

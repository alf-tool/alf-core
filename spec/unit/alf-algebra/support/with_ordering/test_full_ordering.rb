require 'spec_helper'
module Alf
  module Algebra
    describe WithOrdering, 'full_ordering' do
      include WithOrdering

      subject{ full_ordering }

      def keys
        operand.keys
      end

      def heading
        operand.heading
      end

      context 'when the initial ordering covers a key' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id])
        }
        let(:ordering){
          Ordering.new([[:id, :desc]])
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
        let(:ordering){
          Ordering.new([[:name, :desc]])
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
        let(:ordering){
          Ordering.new([[:name, :desc]])
        }
        let(:expected){
          Ordering.new([[:name, :desc], [:id, :asc]])
        }

        it { should eq(expected) }
      end

    end
  end
end

require 'spec_helper'
module Alf
  module Lang
    describe ObjectOriented, 'to_rash' do

      include ObjectOriented.new(supplier_names_relation)

      subject{
        to_rash(options).each_line.map do |line|
          ::Kernel.eval(line)
        end
      }

      before do
        subject.should be_a(Array)
        subject.each{|t| t.should be_a(Hash)}
      end

      after do
        Relation(subject).should eq(_self_operand)
      end

      context 'when an ordering is specified' do
        let(:ordering){ [[:name, :desc]] }
        let(:options){ {:sort => ordering} }
        it 'respects it' do
          expected = supplier_names.sort.reverse
          subject.map{|t| t[:name]}.should eq(expected)
        end
      end

    end
  end
end
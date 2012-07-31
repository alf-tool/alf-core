require 'spec_helper'
module Alf
  describe Relvar, 'to_a' do

    before do
      relvar.should be_a(Relvar)
    end

    after do
      subject.should be_a(Array)
    end

    context 'without options' do
      subject{ relvar.to_a }

      context 'on a base relvar' do
        let(:relvar){ examples_database.relvar(:suppliers) }

        it 'returns an Array' do
          subject
        end
      end

      context 'on a restriction obtained through OO api' do
        let(:relvar){ examples_database.relvar(:suppliers).restrict(:city => "London") }

        it 'returns an Array' do
          subject
        end
      end
    end 

    context 'with an ordering' do
      subject{ relvar.to_a([[:name, :desc]]) }

      after do
        subject.should be_a(Array)
        names = subject.map{|t| t[:name]}
        names.sort{|k1,k2| k2 <=> k1}.should eq(names)
      end

      context 'on a base relvar' do
        let(:relvar){ examples_database.relvar(:suppliers) }

        it 'returns an Array' do
          subject
        end
      end

      context 'on a restriction obtained through OO api' do
        let(:relvar){ examples_database.relvar(:suppliers).restrict(:city => "London") }

        it 'returns an Array' do
          subject
        end
      end
    end 

  end
end
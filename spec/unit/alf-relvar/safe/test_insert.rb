require 'spec_helper'
module Alf
  module Relvar
    describe Safe, "insert" do

      let(:relvar){ Fake.new(id: Integer, name: String, status: Fixnum) }
      let(:tuple) { {id: 1, name: "Jones", status: 20} }

      subject{ safe.insert(tuples); relvar.inserted_tuples.to_a }

      context 'when nothing specified' do
        let(:safe)  { relvar.safe }
        let(:expected){ [ tuple ] }

        context 'with valid tuples' do
          let(:tuples){ [ tuple ] }

          it{ should eq(expected) }
        end

        context 'with a valid tuples (singleton)' do
          let(:tuples){ tuple }

          it{ should eq(expected) }
        end

        context 'with invalid tuples (too many attributes)' do
          let(:tuples){ [ tuple.merge(foo: 'bar') ] }

          it{ should eq(expected) }
        end
      end

      context 'with projections specified' do
        let(:expected){ [ {name: "Jones", status: 20} ] }
        let(:tuples){ [ tuple.merge(id: 1, foo: 'bar') ] }

        context 'with a white list' do
          let(:safe){ relvar.safe(white_list: [:name, :status]) }

          it{ should eq(expected) }
        end

        context 'with a black list' do
          let(:safe){ relvar.safe(black_list: [:id]) }

          it{ should eq(expected) }
        end
      end

    end
  end
end

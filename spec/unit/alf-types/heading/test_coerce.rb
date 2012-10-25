require 'spec_helper'
module Alf
  module Types
    describe Heading, "coerce" do

      let(:heading){ Heading.new(name: String, status: Integer) }

      subject{ heading.coerce(arg) }

      context 'when applied to a Hash' do
        let(:arg){ {name: "Smith", status: "20"} }

        it{ should be_a(Hash) }
        it{ should eq(name: "Smith", status: 20) }
      end

      context 'when applied to a Hash with String keys' do
        let(:arg){ {'name' => "Smith", 'status' => "20"} }

        it{ should be_a(Hash) }
        it{ should eq(name: "Smith", status: 20) }
      end

      context 'when applied to a Tuple' do
        let(:arg){ Tuple(name: "Smith", status: "20") }

        it{ should be_a(Hash) }
        it{ should eq(name: "Smith", status: 20) }
      end

      context 'when applied to an Enumerable' do
        let(:arg){ [{name: "Smith", status: "20"}] }

        it 'should map on it' do
          subject.should eq([{name: "Smith", status: 20}])
        end
      end

      context 'when attributes are missing' do
        let(:arg){ {name: "Smith"} }

        it 'should not create them' do
          subject.should eq(name: "Smith")
        end
      end

      context 'when attributes are added' do
        let(:arg){ {name: "Smith", status: "12", foo: "bar"} }

        it 'should not touch them' do
          subject.should eq(name: "Smith", status: 12, foo: "bar")
        end
      end

    end
  end
end
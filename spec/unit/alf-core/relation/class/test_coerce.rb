require 'spec_helper'
module Alf
  describe Relation, '.coerce' do

    let(:tuples_by_sid){[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'}
    ]}

    subject{ Relation.coerce(arg) }

    context 'on a Relation' do
      let(:arg){ Relation.new tuples_by_sid.to_set }

      it{ should be(arg) }
    end

    context 'on a to_relation capable' do
      let(:arg){ Struct.new(:to_relation).new("Hello") }

      it{ should eq("Hello") }
    end

    context 'on a single Hash' do
      let(:arg){ {:sid => 'S1'} }

      it{ should eq(Relation.new [Tuple(:sid => 'S1')].to_set) }
    end

    context 'on a single Tuple' do
      let(:arg){ Tuple(:sid => 'S1') }

      it{ should eq(Relation.new [arg].to_set) }
    end

    context 'on an array of Hashes' do
      let(:arg){ tuples_by_sid }

      it{ should eq(Relation.new arg.map{|t| Tuple.new(t)}.to_set) }
    end

    context "with unrecognized arg" do
      let(:arg){ nil }
      specify{ lambda{ subject }.should raise_error(TypeError) }
    end

    describe 'the [] alias' do
      it 'supports a list of tuple literals' do
        Relation[{:sid => 'S1'}, {:sid => 'S2'}].size.should eq(2)
      end
    end

    context 'with files and IOs' do
      let(:path){ Path.dir/'to_relation.rash' }

      before{ path.write("{:name => 'Alf'}") }
      after { path.unlink rescue nil         }

      let(:expected){ Relation.new [ Tuple.new(:name => 'Alf') ].to_set }

      context 'on a Path' do
        let(:arg){ path }

        it{ should eq(expected) }
      end
    end

  end
end

require 'spec_helper'
module Alf
  describe Relation, '.coerce' do

    let(:heading) { {sid: String}           }
    let(:type)    { Relation[heading]       }
    let(:tuple)   { {sid: 'S1'}             }
    let(:tuples)  { Set.new << Tuple(tuple) }
    let(:expected){ type.new(tuples)        }

    subject{ Relation.coerce(arg) }

    context 'on a Relation' do
      let(:arg){ expected }

      it{ should be(expected) }
    end

    context 'on a to_relation capable' do
      let(:arg){ Struct.new(:to_relation).new("Hello") }

      it{ should eq("Hello") }
    end

    context 'on a single Hash' do
      let(:arg){ tuple }

      it{ should eq(expected) }
    end

    context 'on a single Tuple' do
      let(:arg){ Tuple(tuple) }

      it{ should eq(expected) }
    end

    context 'on an array of Hashes' do
      let(:arg){ [tuple] }

      it{ should eq(expected) }
    end

    context "with unrecognized arg" do
      let(:arg){ nil }
      specify{ lambda{ subject }.should raise_error(TypeError) }
    end

    context 'with files and IOs' do
      let(:path){ Path.dir/'to_relation.rash' }

      before{ path.write("{:sid => 'S1'}") }
      after { path.unlink rescue nil       }

      context 'on a Path' do
        let(:arg){ path }

        it{ should eq(expected) }
      end
    end

  end
end

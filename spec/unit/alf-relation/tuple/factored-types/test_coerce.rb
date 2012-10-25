require 'spec_helper'
module Alf
  describe Tuple, '.coerce' do

    let(:type) { Tuple[name: String,  status: Integer] }

    subject{ type.coerce(tuple) }

    context 'on single attributes' do
      let(:tuple){ {name: "Jones", status: "20"} }

      it 'coerces the attributes' do
        subject.should be_a(Tuple)
        subject.should be_a(type)
        subject.to_hash.should eq(name: "Jones", status: 20)
      end
    end

    context 'on coercion failure' do
      let(:tuple){ {name: "Jones", status: "bar"} }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error(TypeError, /Unable to coerce `"bar"` to `Integer`/)
      end
    end

    context 'on missing attributes' do
      let(:tuple){ {name: "Jones"} }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error(TypeError, /Heading mismatch/)
      end
    end

    context 'on too much attributes' do
      let(:tuple){ {name: "Jones", foo: "bar"} }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error(TypeError, /Heading mismatch/)
      end
    end

  end
end

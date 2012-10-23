require 'spec_helper'
module Alf
  describe Relation, '.split' do

    let(:type){ Relation[name: String, status: Integer] }

    subject{ type.split(attr_list) }

    context 'with an empty attribute list' do
      let(:attr_list){ AttrList.new([]) }

      it 'splits as expected' do
        subject.should eq([ Relation[{}], type ])
      end

      it 'reuses the initial instance' do
        subject.last.should be(type)
      end
    end

    context 'with an non empty attribute list' do
      let(:attr_list){ AttrList.new([:name]) }

      it 'splits as expected' do
        subject.should eq([ Relation[name: String], Relation[status: Integer] ])
      end
    end

  end
end

require 'spec_helper'
module Alf
  describe Relation, '.project' do

    let(:type){ Relation[name: String, status: Integer] }

    subject{ type.project(attr_list) }

    context 'with an empty attribute list' do
      let(:attr_list){ AttrList.new([]) }

      it 'projects as expected' do
        subject.should be(Relation::DUM.class)
      end
    end

    context 'with an non empty attribute list' do
      let(:attr_list){ AttrList.new([:name]) }

      it 'projects as expected' do
        subject.should eq(Relation[name: String])
      end
    end

    context 'with a full attribute list' do
      let(:attr_list){ AttrList.new([:name, :status]) }

      it 'reuses the initial instance' do
        subject.should be(type)
      end
    end

  end
end

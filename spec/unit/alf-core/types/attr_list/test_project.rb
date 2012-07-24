require 'spec_helper'
module Alf
  describe AttrList, "project" do

    let(:list){ AttrList.new [:id, :name, :status] }

    context '--no-allbut' do
      subject{ list.project(subset) }

      context 'on a proper subset' do
        let(:subset){ [:id, :name] }

        it { should eq(AttrList[:id, :name]) }
      end

      context 'on an empty subset' do
        let(:subset){ [] }

        it{ should eq(AttrList[]) }
      end

      context 'on the same set' do
        let(:subset){ list }

        it{ should eq(list) }
      end
    end

    context '--allbut' do
      subject{ list.project(subset, true) }

      context 'on a proper subset' do
        let(:subset){ [:id, :name] }

        it{ should eq(AttrList[:status]) }
      end

      context 'on an empty subset' do
        let(:subset){ [] }

        it { should eq(AttrList[:id, :name, :status]) }
      end

      context 'on the same set' do
        let(:subset){ list }

        it{ should eq(AttrList[]) }
      end
    end

  end
end

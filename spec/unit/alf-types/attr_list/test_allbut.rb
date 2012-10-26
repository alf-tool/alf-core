require 'spec_helper'
module Alf
  describe AttrList, "project" do

    let(:list){ AttrList.new [:id, :name, :status] }

    subject{ list.allbut(subset) }

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

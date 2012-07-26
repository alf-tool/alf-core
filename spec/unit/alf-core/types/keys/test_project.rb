require 'spec_helper'
module Alf
  describe Keys, "project" do

    let(:keys){
      Keys[ [:id], [:id, :name], [:status] ]
    }
    let(:attrs){ 
      [:id]
    }

    subject{ keys.project(attrs, allbut) }

    context '--no-allbut' do
      let(:allbut)  { false }
      let(:expected){ Keys[ [:id], [] ]  }

      it{ should eq(expected) }
    end

    context '--allbut' do
      let(:allbut)  { true }
      let(:expected){ Keys[ [], [:name], [:status] ] }

      it{ should eq(expected) }
    end

  end
end
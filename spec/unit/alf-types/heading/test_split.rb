require 'spec_helper'
module Alf
  describe Heading, "split" do

    let(:heading){ Heading[id: Integer, name: String] }

    context 'without allbut' do
      subject{ heading.split([:id]) }

      it { should eq([Heading[id: Integer], Heading[name: String]]) }
    end

    context 'without allbut' do
      subject{ heading.split([:id], true) }

      it { should eq([Heading[name: String], Heading[id: Integer]]) }
    end

  end
end

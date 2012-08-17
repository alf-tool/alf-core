require 'spec_helper'
module Alf
  describe Heading, "project" do

    let(:heading){ Heading[:id => Integer, :name => String] }

    context 'without allbut' do
      subject{ heading.project([:id]) }

      it { should eq(Heading[:id => Integer]) }
    end

    context 'with allbut' do
      subject{ heading.project([:id], true) }

      it { should eq(Heading[:name => String]) }
    end

  end
end

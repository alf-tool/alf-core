require 'spec_helper'
module Alf
  describe Heading, "allbut" do

    let(:heading){ Heading[id: Integer, name: String] }

    subject{ heading.allbut([:id]) }

    it { should eq(Heading[name: String]) }

  end
end

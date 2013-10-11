require 'spec_helper'
module Alf
  module Engine
    describe Cog, "to_cog" do

      let(:cog){ Clip.new([], AttrList[:name], true) }

      subject{ cog.to_ascii_tree }

      it { should eq("Clip ..., [:name], {:allbut => true}\n+-- []\n") }

    end
  end
end

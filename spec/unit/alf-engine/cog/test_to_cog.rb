require 'spec_helper'
module Alf
  module Engine
    describe Cog, "to_cog" do

      let(:cog){ Object.new.extend(Cog) }

      subject{ cog.to_cog }

      it { should be(cog) }

    end
  end
end

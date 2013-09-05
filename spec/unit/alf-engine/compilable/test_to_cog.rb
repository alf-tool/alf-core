require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "to_cog" do

      let(:cog){ :a_cog }

      let(:compilable){ Compilable.new(cog) }

      subject{ compilable.to_cog }

      it 'returns the cog' do
        subject.should be(cog)
      end

    end
  end
end

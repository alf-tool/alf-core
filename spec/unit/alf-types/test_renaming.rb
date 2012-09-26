require 'spec_helper'
module Alf
  describe Renaming do

    def Renaming.exemplars
      [
        {},
        {:old1 => :new1},
        {:old1 => :new1, :old2 => :new2}
      ].map{|x| Renaming.coerce(x)}
    end

    let(:type){ Renaming }

    it_should_behave_like 'A valid type implementation'

  end # Renaming
end # Alf

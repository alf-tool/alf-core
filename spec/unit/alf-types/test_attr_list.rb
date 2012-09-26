require 'spec_helper'
module Alf
  describe AttrList do

    def AttrList.exemplars
      [
        [],
        [:a],
        [:a, :b]
      ].map{|arg| AttrList.coerce(arg) }
    end

    let(:type){ AttrList }

    it_should_behave_like 'A valid type implementation'

  end
end

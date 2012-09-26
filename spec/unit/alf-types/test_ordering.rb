require 'spec_helper'
module Alf
  describe Ordering do

    def Ordering.exemplars
      [
        [],
        [:a],
        [[:a, :asc], [:b, :asc]]
      ].map{|x| Ordering.coerce(x)}
    end

    let(:type){ Ordering }

    it_should_behave_like 'A valid type implementation'

  end # Ordering
end # Alf

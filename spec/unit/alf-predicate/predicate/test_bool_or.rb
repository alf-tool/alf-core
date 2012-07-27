require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "or" do

      subject{ left | right }

      let(:left) { Predicate.coerce(:x => 2) }

      let(:right){ Predicate.coerce(:y => 3) }

      it{ should be_a(Predicate) }

      specify{
        subject.to_ruby_code.should eq("(self.x == 2) || (self.y == 3)")
      }

    end
  end
end
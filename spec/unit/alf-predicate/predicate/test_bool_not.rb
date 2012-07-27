require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "!" do

      subject{ !op }

      let(:op) { Predicate.coerce(:x => 2) }

      it{ should be_a(Predicate) }

      specify{
        subject.to_ruby_code.should eq("!(x == 2)")
      }

    end
  end
end
require 'spec_helper'
module Alf
  class Predicate
    describe Comp, "values" do

      subject{ expr.values }

      let(:expr){ Factory.comp(:eq, :x => 2) }

      it{ should eq(:x => 2) }

    end
  end
end

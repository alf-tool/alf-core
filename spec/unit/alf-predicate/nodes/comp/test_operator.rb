require 'spec_helper'
module Alf
  class Predicate
    describe Comp, "operator" do

      subject{ expr.operator }

      let(:expr){ Factory.comp(:eq, :x => 2) }

      it{ should eq(:eq) }

    end
  end
end

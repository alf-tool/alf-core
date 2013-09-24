require 'spec_helper'
module Alf
  class Predicate
    describe QualifiedIdentifier, "qualified" do

      let(:expr){ Factory.qualified_identifier(:t, :id) }

      subject{ expr.qualifier }

      it{ should eq(:t) }

    end
  end
end

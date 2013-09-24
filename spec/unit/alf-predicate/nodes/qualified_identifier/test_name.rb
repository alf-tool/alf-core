require 'spec_helper'
module Alf
  class Predicate
    describe QualifiedIdentifier, "name" do

      let(:expr){ Factory.qualified_identifier(:t, :id) }

      subject{ expr.name }

      it{ should eq(:id) }

    end
  end
end

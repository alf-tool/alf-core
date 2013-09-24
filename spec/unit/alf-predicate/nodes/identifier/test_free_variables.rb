require 'spec_helper'
module Alf
  class Predicate
    describe Identifier, "free_variables" do

      let(:expr){ Factory.identifier(:id) }

      subject{ expr.free_variables }

      it{ should eq(AttrList[:id]) }

    end
  end
end
require 'spec_helper'
module Alf
  class Predicate
    describe VarRef, "free_variables" do

      let(:expr){ Factory.var_ref(:id) }

      subject{ expr.free_variables }

      it{ should eq(AttrList[:id]) }

    end
  end
end
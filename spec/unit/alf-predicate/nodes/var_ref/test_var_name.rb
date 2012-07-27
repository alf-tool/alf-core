require 'spec_helper'
module Alf
  class Predicate
    describe VarRef, "var_name" do

      let(:expr){ Factory.var_ref(:id) }

      subject{ expr.var_name }

      it{ should eq(:id) }

    end
  end
end
require 'spec_helper'
module Alf
  class Predicate
    describe NadicBool, "free_variables" do

      subject{ expr.free_variables }

      context "on a complex attribute comparison" do
        let(:expr){ Factory.comp(:neq, :x => :y, :z => 2) }

        it{ should eq(AttrList[:x, :y, :z]) }
      end

    end
  end
end

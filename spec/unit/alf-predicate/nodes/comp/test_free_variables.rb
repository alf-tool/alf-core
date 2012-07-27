require 'spec_helper'
module Alf
  class Predicate
    describe Comp, "free_variables" do

      subject{ expr.free_variables }

      context "on a simple case" do
        let(:expr){ Factory.comp(:eq, :x => 2) }

        it{ should eq(AttrList[:x]) }
      end

      context "on a attribute comparison" do
        let(:expr){ Factory.comp(:neq, :x => :y) }

        it{ should eq(AttrList[:x, :y]) }
      end

    end
  end
end

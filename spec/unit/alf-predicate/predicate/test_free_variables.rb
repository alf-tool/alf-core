require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "free_variables" do

      subject{ p.free_variables }

      describe "on a comp(:eq)" do
        let(:p){ Predicate.coerce(:x => 2) }

        it{ should eq(AttrList[:x]) }
      end
      
    end
  end
end
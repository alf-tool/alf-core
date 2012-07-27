require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "to_proc" do

      subject{ p.to_proc }

      describe "on a comp(:eq)" do
        let(:p){ Predicate.coerce(:x => 2) }

        it{ should be_a(Proc) }
      end
      
    end
  end
end
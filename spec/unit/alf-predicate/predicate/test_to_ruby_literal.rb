require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "to_ruby_literal" do

      subject{ p.to_ruby_literal }

      describe "on a comp(:eq)" do
        let(:p){ Predicate.coerce(:x => 2) }

        it{ should eq("->(t){ t.x == 2 }") }
      end
      
    end
  end
end
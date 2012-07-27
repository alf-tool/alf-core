require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "to_ruby_code" do

      subject{ p.to_ruby_code }

      describe "on a comp(:eq)" do
        let(:p){ Predicate.coerce(:x => 2) }

        it{ should eq("x == 2") }
      end
      
    end
  end
end
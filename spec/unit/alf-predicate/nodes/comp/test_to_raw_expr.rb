require 'spec_helper'
module Alf
  class Predicate
    describe Comp, "to_raw_expr" do

      subject{ comp.to_raw_expr }

      before do
        subject.should be_a(Sexpr)
        subject.should be_a(Expr)
      end

      context "when a singleton" do
        let(:comp){ Factory.comp(:eq, :x => 2) }
        let(:expected){
          [:eq, [:var_ref, :x], [:literal, 2] ]
        }

        it{ should eq(expected) }
      end

      context "when not a singleton" do
        let(:comp){ Factory.comp(:eq, :x => 2, :u => :v) }
        let(:expected){
          [:and, 
            [:eq, [:var_ref, :x], [:literal, 2] ],
            [:eq, [:var_ref, :u], [:var_ref, :v] ]]
        }

        it{ should eq(expected) }
      end

    end
  end
end

require 'optimizer_helper'
module Alf
  class Optimizer
    describe Search do

      let(:operand_1){ an_operand.with_heading(:id => String) }

      # replaces project by clip
      let(:processor_1){
        lambda{|expr, search|
          clip(search.apply(expr.operand), expr.attributes, :allbut => expr.allbut)
        }
      }
      # adds an autonum before rename 
      let(:processor_2){
        lambda{|expr, search| autonum(search.copy_and_apply(expr), :auto) }
      }
      let(:optimizer){
        Optimizer.new.register(processor_1, Algebra::Project).
                      register(processor_2, Algebra::Rename)
      }

      subject{ optimizer.call(expr) }

      let(:expr){
        (project (rename (project operand_1, [:bar]), :foo => :bar), [:foo])
      }

      let(:expected){
        (clip (autonum (rename (clip operand_1, [:bar]), :foo => :bar), :auto), [:foo])
      }

      it{ should eq(expected) }

    end
  end
end
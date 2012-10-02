require 'optimizer_helper'
module Alf
  class Optimizer
    describe Restrict, "on_matching" do

      let(:left) { an_operand.with_heading(id: Integer, name: String) }
      let(:right){ an_operand.with_heading(id: Integer, city: String) }

      let(:id_pred)  { comp(id: 1)       }
      let(:name_pred){ comp(name: 'foo') }

      let(:expr)     { restrict(matching(left, right), predicate) }
      let(:optimized){ Restrict.new.call(expr)                    }
      let(:expected) { Support.to_lispy(expected_rewrite)         }

      subject{ Support.to_lispy(optimized) }

      context 'when the restriction does not touch right attributes' do
        let(:predicate){ name_pred }
        let(:expected_rewrite){ matching(restrict(left, predicate), right) }
      
        it{ should eq(expected) }
      end

      context 'when the restriction does touch right attributes' do
        let(:predicate){ id_pred }
        let(:expected_rewrite){ matching(restrict(left, predicate), restrict(right, predicate)) }
      
        it{ should eq(expected) }
      end

      context 'when the restriction partly touches right attributes' do
        let(:predicate){ id_pred & name_pred }
        let(:expected_rewrite){ matching(restrict(left, predicate), restrict(right, id_pred)) }
      
        it{ should eq(expected) }
      end

    end
  end
end

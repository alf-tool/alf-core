require 'optimizer_helper'
module Alf
  class Optimizer
    describe Restrict, "on_join" do

      let(:left) { an_operand.with_heading(id: Integer, name: String) }
      let(:right){ an_operand.with_heading(id: Integer, city: String) }

      let(:id_pred)  { comp(id: 1)       }
      let(:name_pred){ comp(name: 'foo') }
      let(:city_pred){ comp(city: 'bar') }

      let(:expr)     { restrict(join(left, right), predicate) }
      let(:optimized){ Restrict.new.call(expr)                }
      let(:expected) { Support.to_lispy(expected_rewrite)     }

      subject{ Support.to_lispy(optimized) }

      # not analyzable
      context 'when the restriction is a native one' do
        let(:predicate){ Predicate.native(->{ id > 12 }) }
        let(:expected_rewrite){ restrict(join(left, right), predicate) }
      
        it 'should be as expected' do
          optimized.should be_a(Algebra::Restrict)
          optimized.operand.should be(expr.operand)
        end
      end

      # covered by one restriction pushed

      context 'when the restriction applies to left only' do
        let(:predicate){ name_pred }
        let(:expected_rewrite){ join(restrict(left, predicate), right) }
      
        it{ should eq(expected) }
      end
      
      context 'when the restriction applies to right only' do
        let(:predicate){ city_pred }
        let(:expected_rewrite){ join(left, restrict(right, predicate)) }
      
        it{ should eq(expected) }
      end
      
      context 'when the restriction is a OR on left' do
        let(:predicate){ id_pred | name_pred }
        let(:expected_rewrite){ join(restrict(left, predicate), right) }
      
        it{ should eq(expected) }
      end

      context 'when the restriction is a OR on right' do
        let(:predicate){ id_pred | city_pred }
        let(:expected_rewrite){ join(left, restrict(right, predicate)) }
      
        it{ should eq(expected) }
      end

      # covered by the conjunction of pushed restrictions

      context 'when the restriction applies to both operands' do
        let(:predicate){ id_pred }
        let(:expected_rewrite){ join(restrict(left, predicate), restrict(right, predicate)) }
      
        it{ should eq(expected) }
      end

      context 'when the restriction is a AND on left' do
        let(:predicate){ id_pred & name_pred }
        let(:expected_rewrite){ join(restrict(left, predicate), restrict(right, id_pred)) }
      
        it{ should eq(expected) }
      end
      
      context 'when the restriction is a AND to be splitted' do
        let(:predicate){ city_pred & name_pred }
        let(:expected_rewrite){ join(restrict(left, name_pred), restrict(right, city_pred)) }
      
        it{ should eq(expected) }
      end

      # not fully covered by a conjunction
      context 'when the restriction is an un-splittable OR' do
        let(:predicate){ city_pred | name_pred }
        let(:expected_rewrite){ restrict(join(left, right), predicate) }
      
        it{ should eq(expected) }
      end

      context 'when the restriction is an un-splittable AND/OR' do
        let(:predicate){ (city_pred & name_pred) | id_pred }
        let(:expected_rewrite){ restrict(join(left, right), predicate) }
      
        it{ should eq(expected) }
      end

      context 'when the restriction is a partly un-splittable OR' do
        let(:predicate){ id_pred & (city_pred | name_pred) }
        let(:expected_rewrite){ restrict(join(restrict(left, id_pred), restrict(right, id_pred)), city_pred | name_pred) }
      
        it{ should eq(expected) }
      end

    end
  end
end

require 'spec_helper'
module Alf
  describe Types do
    include Types

    describe "common_super_type" do

      it 'works on same types' do
        common_super_type(String, String).should eq(String)
      end

      it 'works with related types' do
        common_super_type(Fixnum, Integer).should eq(Integer)
        common_super_type(Fixnum, Float).should eq(Numeric)
      end

      it 'works with true/false/boolean classes' do
        common_super_type(TrueClass, FalseClass).should eq(Boolean)
        common_super_type(TrueClass, Boolean).should eq(Boolean)
        common_super_type(Boolean, TrueClass).should eq(Boolean)
        common_super_type(Boolean, Boolean).should eq(Boolean)
      end

      it 'fallbacks to Object' do
        common_super_type(Fixnum, String).should eq(Object)
      end

      it 'works nicely on same relation types' do
        left  = Relation[pid: String]
        right = Relation[pid: String]
        common_super_type(left, right).should eq(left)
      end

      it 'works nicely on compatible relation types' do
        left  = Relation[pid: Fixnum]
        right = Relation[pid: Integer]
        common_super_type(left, right).should eq(right)
      end

      it 'works nicely on same tuple types' do
        left  = Tuple[pid: String]
        right = Tuple[pid: String]
        common_super_type(left, right).should eq(left)
      end

      it 'works nicely on compatible relation types' do
        left  = Tuple[pid: Fixnum]
        right = Tuple[pid: Integer]
        common_super_type(left, right).should eq(right)
      end

      it 'fallbacks to Tuple when tuple types do not agree' do
        left  = Tuple[pid: String]
        right = Tuple[{}]
        common_super_type(left, right).should eq(Tuple)
      end

      it 'fallbacks to Relation when relation types do not agree' do
        left  = Relation[pid: String]
        right = Relation[{}]
        common_super_type(left, right).should eq(Relation)
      end
    end

  end # describe Types
end # module Alf

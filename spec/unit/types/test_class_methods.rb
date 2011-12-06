require 'spec_helper'
module Alf
  describe Types do
    include Types

    describe "common_super_type" do

      it 'should work on same types' do
        common_super_type(String, String).should eq(String)
      end

      it 'should work with related types' do
        common_super_type(Fixnum, Integer).should eq(Integer)
        common_super_type(Fixnum, Float).should eq(Numeric)
      end

      it 'should work with un related types' do
        common_super_type(Fixnum, String).should eq(Object)
      end

    end

  end # describe Types
end # module Alf

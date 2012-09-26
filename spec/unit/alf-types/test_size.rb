require 'spec_helper'
module Alf
  module Types
    describe Size do

      describe "===" do

        it 'should recognize 0' do
          (Size === 0).should be_true
        end

        it 'should recognize any positive integer' do
          (Size === 10).should be_true
        end

        it 'should not recognize negative integers' do
          (Size === -1).should be_false
        end

        it 'should not recognize non integers' do
          (Size === 10.0).should be_false
          (Size === "12").should be_false
        end

      end # ===

      describe "coerce" do

        it 'should coerce strings correctly' do
          Size.coerce("0").should eq(0)
          Size.coerce("10").should eq(10)
        end

        it 'should raise Myrrha::Error on negative integers' do
          lambda{ Size.coerce("-1") }.should raise_error(Myrrha::Error)
        end

        it 'should raise Myrrha::Error on non integers' do
          lambda{ Size.coerce("hello") }.should raise_error(Myrrha::Error)
        end

      end # coerce

      describe "from_argv" do

        it 'should allow an empty array' do
          Size.from_argv([]).should eq(0)
        end

        it 'should use the default value on empty array' do
          Size.from_argv([], :default => 10).should eq(10)
        end

        it 'correctly coerce when non empty' do
          Size.from_argv(["12"]).should eq(12)
        end

        it 'raise an ArgumentError on big array' do
          lambda{ 
            Size.from_argv(["12", "hello"])
          }.should raise_error(ArgumentError)
        end

        it 'raise an ArgumentError on non coercable' do
          lambda{ 
            Size.from_argv(["hello"])
          }.should raise_error(Myrrha::Error)
        end

      end

    end
  end
end

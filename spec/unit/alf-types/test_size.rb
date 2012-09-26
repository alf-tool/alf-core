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

    end
  end
end

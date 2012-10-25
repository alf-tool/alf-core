require 'spec_helper'
module Alf
  module Types
    describe Size, "coerce" do

      it 'should coerce strings correctly' do
        Size.coerce("0").should eq(0)
        Size.coerce("10").should eq(10)
      end

      it 'should raise TypeError on negative integers' do
        lambda{ Size.coerce("-1") }.should raise_error(TypeError)
      end

      it 'should raise on non integers' do
        lambda{
          Size.coerce("hello")
        }.should raise_error(TypeError)
      end

    end
  end
end

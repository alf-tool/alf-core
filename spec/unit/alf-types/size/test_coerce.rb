require 'spec_helper'
module Alf
  module Types
    describe Size, "coerce" do

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

    end
  end
end

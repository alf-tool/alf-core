require 'spec_helper'
module Alf
  describe "Support#to_ruby_literal" do

    it 'works on Symbols' do
      Support.to_ruby_literal(:name).should eql(":name")
    end

    it 'works on Integers' do
      Support.to_ruby_literal(12).should eql("12")
    end

    it 'works on DateTime' do
      dt = DateTime.parse('2012-05-11T12:00:00+00:00')
      rl = Support.to_ruby_literal(dt)
      ::Kernel.eval(rl).should eq(dt)
    end

    it 'works on Time' do
      t = Time.parse('2012-05-11T12:00:00+00:00')
      rl = Support.to_ruby_literal(t)
      ::Kernel.eval(rl).should eq(t)
    end

  end
end

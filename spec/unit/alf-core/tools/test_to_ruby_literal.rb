require 'spec_helper'
module Alf
  describe "Tools#to_ruby_literal" do

    it 'works on Integers' do
      Tools.to_ruby_literal(12).should eql("12")
    end

    it 'works on DateTime' do
      dt = DateTime.parse('2012-05-11T12:00:00+02:00')
      rl = Tools.to_ruby_literal(dt)
      rl.should eql("DateTime.parse('2012-05-11T12:00:00+02:00')")
      ::Kernel.eval(rl).should eq(dt)
    end

    it 'works on Time' do
      t = Time.parse('2012-05-11T12:00:00+02:00')
      rl = Tools.to_ruby_literal(t)
      rl.should eql("Time.parse('2012-05-11T12:00:00+02:00')")
      ::Kernel.eval(rl).should eq(t)
    end

  end
end

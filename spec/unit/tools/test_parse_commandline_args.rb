require 'spec_helper'
module Alf
  describe "Tools#parse_commandline_args" do
    
    subject{ Tools.parse_commandline_args(args) }
    
    describe "on empty string" do
      let(:args){ "" }
      it { should eq([]) }
    end

    describe "on pseudo empty string" do
      let(:args){ "   " }
      it { should eq([]) }
    end

    describe "on a single arg" do
      let(:args){ "--text" }
      it { should eq(["--text"]) }
    end

    describe "on a multiple args" do
      let(:args){ "--text --size=10" }
      it { should eq(["--text", "--size=10"]) }
    end

    describe "on single quoted arg" do
      let(:args){ "'hello'" }
      it { should eq(["hello"]) }
    end

    describe "on single quoted arg with spacing" do
      let(:args){ "'hello the world'" }
      it { should eq(["hello the world"]) }
    end
    
    describe "on double quoted arg" do
      let(:args){ '"hello"' }
      it { should eq(["hello"]) }
    end

    describe "on double quoted arg with spacing" do
      let(:args){ "'hello the world'" }
      it { should eq(['hello the world']) }
    end
  end
end

require 'spec_helper'
module Alf
  describe Reader::AlfFile do

    class TestAdapter < Alf::Adapter
      def relvar(name)
        [{:status => 10},{:status => 30}]
      end
    end

    let(:io){ StringIO.new(expr) }

    subject{
      Reader::AlfFile.new(io, TestAdapter.new(nil)).to_a
    }

    describe "on pure functional expressions" do
      let(:expr){ "(restrict :suppliers, lambda{status > 20})" }
      it{ should == [{:status => 30}]}
    end

    describe "on impure functional expressions" do
      let(:expr){
      <<-EOF
        xxx = (restrict :suppliers, lambda{status > 20})
        (extend xxx, :rev => lambda{ -status })
      EOF
      }
      it{ should == [{:status => 30, :rev => -30}]}
    end

  end
end
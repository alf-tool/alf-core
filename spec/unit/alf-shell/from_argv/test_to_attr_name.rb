require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, AttrName)" do

    subject{ Shell.from_argv(argv, AttrName) }

    context "with a String" do
      let(:argv){ %w{hello} }
      it{ should eq(:hello) }
    end

    context "with nothing" do
      let(:argv){ %w{} }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

    context "with more than one string" do
      let(:argv){ %w{hello world} }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

  end
end

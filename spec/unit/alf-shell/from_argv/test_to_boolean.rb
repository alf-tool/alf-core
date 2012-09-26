require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Boolean)" do

    subject{ Shell.from_argv(argv, Boolean) }

    context "with a String" do
      let(:argv){ %w{true} }
      it{ should eq(true) }
    end

    context "with nothing" do
      let(:argv){ %w{} }
      it{ should eq(false) }
    end

    context "with an invalid string" do
      let(:argv){ %w{hello} }
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

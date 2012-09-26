require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, AttrList)" do

    subject{ Shell.from_argv(argv, AttrList) }

    context "on an empty array" do
      let(:argv){ [] }
      it{ should eq(AttrList.new([])) }
    end

    context "on a singleton" do
      let(:argv){ ["hello"] }
      it{ should eq(AttrList.new([:hello])) }
    end

    context "on multiple strings" do
      let(:argv){ ["hello", "world"] }
      it{ should eq(AttrList.new([:hello, :world])) }
    end

    context "when passed an unrecognized argument" do
      let(:argv){ :not_recognized }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

  end
end

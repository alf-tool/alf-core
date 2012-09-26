require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Heading)" do

    subject{ Shell.from_argv(argv, Heading) }

    context "on an empty array" do
      let(:argv){ [] }
      it{ should eq(Heading.new({})) }
    end

    context "on a single pair" do
      let(:argv){ ["name", "String"] }
      it{ should eq(Heading.new :name => String) }
    end

    context "on a double pair" do
      let(:argv){ ["name", "String", "age", "Fixnum"] }
      it{ should eq(Heading.new :name => String, :age => Fixnum) }
    end

    context "on odd number of strings" do
      let(:argv){ ["hello", "world", "foo"] }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

    context "when passed an unrecognized argument" do
      let(:argv){ :not_recognized }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

  end
end

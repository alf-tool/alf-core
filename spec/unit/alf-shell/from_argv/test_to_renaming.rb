require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Renaming)" do

    subject{ Shell.from_argv(argv, Renaming) }

    context "from an empty Array" do
      let(:argv){ [] }
      it{ should eq(Renaming.new({})) }
    end

    context "from an Array of two elements" do
      let(:argv){ ["old", "new"] }
      it{ should eq(Renaming.new(:old => :new)) }
    end

    context "from an Array of four elements" do
      let(:argv){ ["old", "new", "hello", "world"] }
      it{ should eq(Renaming.new(:old => :new, :hello => :world)) }
    end

  end
end

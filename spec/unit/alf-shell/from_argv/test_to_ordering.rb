require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Ordering)" do

    subject{ Shell.from_argv(argv, Ordering) }

    context "on an empty array" do
      let(:argv){ [] }
      it{ should eq(Ordering.new([])) }
    end

    context "on a singleton" do
      let(:argv){ ["hello"] }
      it{ should eq(Ordering.new([[:hello, :asc]])) }
    end

    context "on multiple strings without explit directions" do
      let(:argv){ ["hello", "world"] }
      it{ should eq(Ordering.new([[:hello, :asc], [:world, :asc]])) }
    end

    context "on multiple strings with explit directions" do
      let(:argv){ ["hello", "asc", "world", "desc"] }
      it{ should eq(Ordering.new([[:hello, :asc], [:world, :desc]])) }
    end

  end
end

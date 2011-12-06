require 'spec_helper'
module Alf
  describe Renaming do

    describe "the class itself" do
      let(:type){ Renaming }
      def Renaming.exemplars
        [
          {},
          {:old1 => :new1},
          {:old1 => :new1, :old2 => :new2}
        ].map{|x| Renaming.coerce(x)}
      end
      it_should_behave_like 'A valid type implementation'
    end

    describe "coerce" do

      subject{ Renaming.coerce(arg) }
      let(:expected){ Renaming.new(:old1 => :new1, :old2 => :new2) }

      describe "from a Renaming" do
        let(:arg){ Renaming.new(:old1 => :new1, :old2 => :new2) }
        it{ should eq(expected) }
      end

      describe "from a Hash" do
        let(:arg){ {"old1" => "new1", "old2" => "new2"} }
        it{ should eq(expected) }
      end

      describe "from an Array" do
        let(:arg){ ["old1", "new1", "old2", "new2"] }
        it{ should eq(expected) }
      end

    end # coerce

    describe "from_argv" do

      subject{ Renaming.from_argv(argv) }

      describe "from an empty Array" do
        let(:argv){ [] }
        it{ should eq(Renaming.new({})) }
      end

      describe "from an Array of two elements" do
        let(:argv){ ["old", "new"] }
        it{ should eq(Renaming.new(:old => :new)) }
      end

      describe "from an Array of four elements" do
        let(:argv){ ["old", "new", "hello", "world"] }
        it{ should eq(Renaming.new(:old => :new, :hello => :world)) }
      end

    end # from_argv

    describe "rename_tuple" do
      let(:r){ Renaming.coerce(["old", "new"]) } 

      it 'should rename correctly' do
        tuple    = {:old => :a, :other => :b}
        expected = {:new => :a, :other => :b}
        r.rename_tuple(tuple).should eq(expected)
      end

    end # rename_tuple

  end # Renaming
end # Alf

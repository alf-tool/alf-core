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

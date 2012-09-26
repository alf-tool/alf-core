require 'spec_helper'
module Alf
  describe Renaming, "coerce" do

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

  end # Renaming
end # Alf

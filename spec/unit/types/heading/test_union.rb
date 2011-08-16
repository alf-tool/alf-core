require 'spec_helper' 
module Alf
  module Types
    describe "Heading", "#union" do
      subject{ h1 + h2 }

      describe "on empty headings" do
        let(:h1){ Heading::EMPTY }
        let(:h2){ Heading::EMPTY }
        it{ should eq(Heading::EMPTY) }
      end

      describe "on equal headings" do
        let(:h1){ Heading[:name => String, :price => Float] }
        let(:h2){ Heading[:name => String, :price => Float] }
        it{ should eq(Heading[:name => String, :price => Float]) }
      end

    end
  end
end

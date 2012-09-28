require 'spec_helper'
module Alf
  describe Heading do

    describe "the class itself" do
      let(:type){ Heading }
      def Heading.exemplars
        [
          {},
          {:a => String},
          {:a => String, :b => Date}
        ].map{|x| Heading.coerce(x)}
      end
      it_should_behave_like 'A valid type implementation'
    end

    let(:h0){ Heading.new({}) }
    let(:h1){ Heading.new(:name => String) }
    let(:h2){ Heading.new(:name => String, :price => Float) }

    it 'should be Enumerable' do
      h2.map{|k,v| [k,v]}.to_set.should eq([[:name, String], [:price, Float]].to_set)
    end

    describe "[]" do

      specify "it should mimic coerce" do
        Heading[:name => String].should eq(h1)
        Heading["name" => "String"].should eq(h1)
        Heading[{}].should eq(h0)
        Heading[[]].should eq(h0)
        Heading[["name", "String"]].should eq(h1)
      end

      specify "should raise ArgumentError on error" do
        lambda{ Heading[true] }.should raise_error(TypeError)
      end

    end # []

    describe "EMPTY" do
      subject{ Heading::EMPTY }
      it{ should be_a(Heading) }
      it_should_behave_like "A value"
    end

    describe "h0" do
      subject{ h0 }
      it { should == Heading::EMPTY }
      it_should_behave_like "A value" 
    end

    describe "h1" do
      subject{ h1 }
      it_should_behave_like "A value" 
    end

  end 
end

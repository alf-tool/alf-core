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

    describe "coerce" do

      it "should work with a heading" do
        Heading.coerce(h0).should eq(h0)
        Heading.coerce(h1).should eq(h1)
      end

      it "should work with hashes" do
        Heading.coerce(:name => String).should eq(h1)
        Heading.coerce("name" => "String").should eq(h1)
        Heading.coerce({}).should eq(h0)
      end

      it "should work with arrays" do
        Heading.coerce([]).should eq(h0)
        Heading.coerce(["name", "String"]).should eq(h1)
      end

      specify "should raise ArgumentError on error" do
        lambda{ Heading.coerce(true) }.should raise_error(Myrrha::Error)
      end

    end # coerce

    describe "[]" do

      specify "it should mimic coerce" do
        Heading[:name => String].should eq(h1)
        Heading["name" => "String"].should eq(h1)
        Heading[{}].should eq(h0)
        Heading[[]].should eq(h0)
        Heading[["name", "String"]].should eq(h1)
      end

      specify "should raise ArgumentError on error" do
        lambda{ Heading[true] }.should raise_error(Myrrha::Error)
      end

    end # []

    describe "cardinality" do

      it "should return the number of pairs" do
        h0.cardinality.should eq(0)
        h1.cardinality.should eq(1)
        h2.cardinality.should eq(2)
      end

      it 'should be aliased as count' do
        [h0, h1, h2].all?{|h| h.cardinality == h.count}.should be_true
      end

      it 'should be aliased as size' do
        [h0, h1, h2].all?{|h| h.cardinality == h.size}.should be_true
      end

    end # cardinality, count, size

    it "should implement a to_h method" do
      h0.to_h.should eq({})
      h1.to_h.should eq(:name => String)
      h2.to_h.should eq(:name => String, :price => Float)
    end

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

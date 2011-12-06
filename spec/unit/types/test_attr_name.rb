require 'spec_helper'
module Alf
  describe AttrName do

    describe "===" do

      it "should allow normal names" do
        (AttrName === :city).should be_true
      end

      it "should allow underscores" do
        (AttrName === :my_city).should be_true
      end

      it "should allow numbers" do
        (AttrName === :city2).should be_true
      end

      it "should allow question marks and bang" do
        (AttrName === :big?).should be_true
        (AttrName === :big!).should be_true
      end

      it "should not allow strange attribute names" do
        (AttrName === "$$$".to_sym).should be_false
      end

    end # ===

    describe "coerce" do

      it 'should work on valid attribute names' do
        AttrName.coerce("city").should eq(:city)
        AttrName.coerce(:big?).should eq(:big?)
      end

      it 'should be aliased as []' do
        AttrName["city"].should eq(:city)
      end

      it 'should raise ArgumentError otherwise' do
        lambda{ AttrName["!123"] }.should raise_error(ArgumentError)
      end

    end # coerce

    describe "from_argv" do

      subject{ AttrName.from_argv(argv, opts) }

      describe "with a String" do
        let(:argv){ %w{hello} }
        let(:opts) {{}}
        it{ should eq(:hello) }
      end

      describe "with nothing but a default" do
        let(:argv){ %w{} }
        let(:opts){ {:default => :hello} }
        it{ should eq(:hello) }
      end

      describe "with nothing and no default" do
        let(:argv){ %w{} }
        let(:opts){ {} }
        specify{ lambda{subject}.should raise_error(ArgumentError) }
      end

      describe "with more than one string" do
        let(:argv){ %w{hello world} }
        let(:opts){ {} }
        specify{ lambda{subject}.should raise_error(ArgumentError) }
      end

    end # from_argv

  end
end

require 'spec_helper'
module Alf
  describe AttrName, "from_argv" do

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

  end
end

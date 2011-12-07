require 'spec_helper'
module Alf
  describe Boolean do

    describe "from_argv" do

      subject{ Boolean.from_argv(argv, opts) }

      describe "with a String" do
        let(:argv){ %w{true} }
        let(:opts) {{}}
        it{ should eq(true) }
      end

      describe "with nothing but a default" do
        let(:argv){ %w{} }
        let(:opts){ {:default => true} }
        it{ should eq(true) }
      end

      describe "with nothing and no default" do
        let(:argv){ %w{} }
        let(:opts){ {} }
        it{ should eq(false) }
      end

      describe "with an invalid string" do
        let(:argv){ %w{hello} }
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

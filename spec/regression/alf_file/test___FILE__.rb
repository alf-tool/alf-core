require 'spec_helper'
module Alf
  describe Reader::AlfFile do
    subject{
      Reader::AlfFile.new(File.expand_path("../__FILE__.alf", __FILE__), Alf.examples)
    }

    specify {
      subject.to_relation.should == Relation[
        {:city => "London"},
        {:city => "Paris"},
        {:city => "Athens"}
      ]
    }

  end
end

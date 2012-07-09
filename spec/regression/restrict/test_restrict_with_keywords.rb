require 'spec_helper'
module Alf
  describe "(restrict xxx, :keyword => ...)" do

    it "should support using a keyword on Relation" do
      rel = Relation[{:when => "now"}]
      rel.restrict(:when => "now").should eq(rel)
    end

    it "should support using a keyword on Lispy" do
      Database.examples.query do
        (restrict (extend :suppliers, {:when => lambda{"notnow"}}), {:when => "now"})
      end.should eq(Relation::DUM)
    end

  end
end

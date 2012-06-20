require 'spec_helper'
module Alf
  describe Relation do

    let(:rel){Alf::Relation[
      {:qty => 1},
      {:qty => 2},
      {:qty => 3},
      {:qty => 4}
    ]}

    it "avg" do
      rel.avg{ qty }.should eq(2.5)
    end

    it "collect", :ruby19 => true do
      rel.collect{ qty }.should eq([1, 2, 3, 4])
    end

    it "concat", :ruby19 => true do
      rel.concat{ qty }.should eq("1234")
    end

    it "count" do
      rel.count.should eq(4)
    end

    it "max" do
      rel.max{ qty }.should eq(4)
    end

    it "min" do
      rel.min{ qty }.should eq(1)
    end

    it "sum" do
      rel.sum{ qty }.should eq(10)
    end

  end
end

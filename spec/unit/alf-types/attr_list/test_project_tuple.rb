require 'spec_helper'
module Alf
  describe AttrList, "project_tuple" do 

    let(:key){ AttrList.new [:a, :b] }
    let(:tuple){ {:a => 1, :b => 2, :c => 3} }

    describe "when used without allbut" do
      subject{ key.project_tuple(tuple) }
      it{ should eq({:a => 1, :b => 2}) }
    end

    describe "when used with allbut set to true" do
      subject{ key.project_tuple(tuple, true) }
      it{ should eq({:c => 3}) }
    end

    describe "when used without allbut set to false" do
      subject{ key.project_tuple(tuple, false) }
      it{ should eq({:a => 1, :b => 2}) }
    end

    specify "the documentation example" do
      list = AttrList.new([:name])
      tuple = {:name => "Jones", :city => "London"}
      list.project_tuple(tuple).should eq({:name => "Jones"})
      list.project_tuple(tuple, true).should eq({:city => "London"})
    end

  end
end

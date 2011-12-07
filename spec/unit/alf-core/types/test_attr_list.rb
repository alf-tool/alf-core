require 'spec_helper'
module Alf
  describe AttrList do

    describe "the class itself" do
      let(:type){ AttrList }
      def AttrList.exemplars
        [
          [],
          [:a],
          [:a, :b]
        ].map{|arg| AttrList.coerce(arg) }
      end
      it_should_behave_like 'A valid type implementation'
    end

    describe "coerce" do

      subject{ AttrList.coerce(arg) }

      describe "when passed a AttrList" do
        let(:arg){ [:a, :b] } 
        it{ should eq(AttrList.new(arg)) }
      end

      describe "when passed an Ordering" do
        let(:arg){ Ordering.new [[:a, :asc], [:b, :asc]] }
        it{ should eq(AttrList.new([:a, :b])) }
      end

      describe "when passed an array" do
        let(:arg){ [:a, :b] }
        it{ should eq(AttrList.new([:a, :b])) }
      end

      describe "when passed an unrecognized argument" do
        let(:arg){ :not_recognized }
        specify{
          lambda{ subject }.should raise_error(ArgumentError)
        }
      end

    end # coerce

    describe "from_argv" do

      subject{ AttrList.from_argv(argv) }

      describe "on an empty array" do
        let(:argv){ [] }
        it{ should eq(AttrList.new([])) }
      end

      describe "on a singleton" do
        let(:argv){ ["hello"] }
        it{ should eq(AttrList.new([:hello])) }
      end

      describe "on multiple strings" do
        let(:argv){ ["hello", "world"] }
        it{ should eq(AttrList.new([:hello, :world])) }
      end

      describe "when passed an unrecognized argument" do
        let(:argv){ :not_recognized }
        specify{
          lambda{ subject }.should raise_error(ArgumentError)
        }
      end

    end # from_argv

    describe "to_ordering" do

      describe "without direction" do
        subject{ AttrList.coerce(attrs).to_ordering }
        let(:attrs){ [:a, :b] }
        it{ should eq(Ordering.new [[:a, :asc], [:b, :asc]])}
      end

      describe "with a direction" do
        subject{ AttrList.coerce(attrs).to_ordering(direction) }
        let(:attrs){ [:a, :b] }
        let(:direction){ :desc }
        it{ should eq(Ordering.new [[:a, :desc], [:b, :desc]])}
      end

    end # to_ordering

    describe "split_tuple" do 

      let(:key){ AttrList.new [:a, :b] }
      let(:tuple){ {:a => 1, :b => 2, :c => 3} }

      describe "when used without allbut" do
        subject{ key.split_tuple(tuple) }
        it{ should eq([{:a => 1, :b => 2}, {:c => 3}]) }
      end

      describe "when used with allbut set to true" do
        subject{ key.split_tuple(tuple, true) }
        it{ should eq([{:c => 3}, {:a => 1, :b => 2}]) }
      end

      describe "when used with allbut set to false" do
        subject{ key.split_tuple(tuple, false) }
        it{ should eq([{:a => 1, :b => 2}, {:c => 3}]) }
      end

      specify "the documentation example" do
        list = AttrList.new([:name])
        tuple = {:name => "Jones", :city => "London"}
        list.split_tuple(tuple).should eq([{:name => "Jones"}, {:city => "London"}])
        list.split_tuple(tuple, true).should eq([{:city => "London"}, {:name => "Jones"}])
      end

    end # split

    describe "project_tuple" do 

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

    end # project

    it "should define a value" do
      l1 = AttrList.new [:a, :b]
      l2 = AttrList.new [:a, :b]
      l3 = AttrList.new [:a]

      l1.should == l2
      l1.should eq(l2)

      l1.should_not == l3
      l1.should_not eq(l3)

      {l1 => 1, l2 => 2}.size.should eq(1)
    end

  end
end

require 'spec_helper'
module Alf
  describe Tools, ".to_lispy" do
    
    subject{ Tools.to_lispy(value) } 
    
    describe "on an AttrName" do
      let(:value){ :city }
      it { should eq(":city") }
    end

    describe "on an AttrList" do
      let(:value){ AttrList.new([:name, :city]) }
      it { should eq("[:name, :city]") }
    end

    describe "on a Heading" do
      let(:value){ Heading.new(:name => String, :allbut => Boolean) }
      it { should eq("{:name => String, :allbut => Myrrha::Boolean}") }
    end

    describe "on an Ordering" do
      let(:value){ Ordering.new([[:name, :asc], [:city, :desc]]) }
      it { should eq("[[:name, :asc], [:city, :desc]]") }
    end

    describe "on a Renaming" do
      let(:value){ Renaming.new(:old => :new) }
      it { should eq("{:old => :new}") }
    end

    describe "on a Proxy" do
      let(:value){ Iterator::Proxy.new(nil, :suppliers) }
      it { should eq(":suppliers") }
    end

    describe "on an nullary operator" do
      let(:value){ Alf.lispy.run(%w{generator -- 10 -- id}) } 
      it { should eq("(generator 10, :id)") }
    end

    describe "on an monadic operator with an option" do
      let(:value){ Alf.lispy.run(%w{project --allbut suppliers -- city}) } 
      it { should eq("(project :suppliers, [:city], {:allbut => true})") }
    end

  end
end

require 'spec_helper'
module Alf
  describe Tools, ".to_lispy" do

    it "should have a valid example" do
      expr = Alf.lispy.compile{ 
       (project :suppliers, [:name])
      }
      Tools.to_lispy(expr).should eq("(project :suppliers, [:name])")
    end

    subject{ Tools.to_lispy(value) } 

    describe "on a Proxy" do
      let(:value){ Iterator::Proxy.new(Environment.examples, :suppliers) }
      it { should eq(":suppliers") }
    end

    describe "on an AttrName" do
      let(:value){ :city }
      it { should eq(":city") }
    end

    describe "on an AttrList" do
      let(:value){ AttrList.new([:name, :city]) }
      it { should eq("[:name, :city]") }
    end

    describe "on a Heading" do
      let(:value){ Heading.new(:name => String) }
      it { should eq("{:name => String}") }
    end

    describe "on an Ordering" do
      let(:value){ Ordering.new([[:name, :asc], [:city, :desc]]) }
      it { should eq("[[:name, :asc], [:city, :desc]]") }
    end

    describe "on a Renaming" do
      let(:value){ Renaming.new(:old => :new) }
      it { should eq("{:old => :new}") }
    end

    describe "on an Aggregation" do
      let(:value){ Aggregator.coerce("sum{ qty*price }") }
      it { should eq("sum{ qty*price }") }
    end

    describe "on a TupleExpression" do
      let(:value){ TupleExpression.coerce(arg) }

      describe "When built from a string" do
        let(:arg){ "status.upcase" }
        it{ should eq("->{ status.upcase }")}
      end

      describe "When built from a symbol" do
        let(:arg){ :status }
        it{ should eq("->{ status }")}
      end

    end # TupleExpression

    describe "on a TuplePredicate" do
      let(:value){ TuplePredicate.coerce(arg) }

      describe "When built from a TupleExpression" do
        let(:arg){ TupleExpression.coerce("status > 10") }
        it{ should eq("->{ status > 10 }")}
      end

      describe "When built from a boolean" do
        let(:arg){ true }
        it{ should eq("->{ true }")}
      end

      describe "When built from a String" do
        let(:arg){ "status > 10" }
        it{ should eq("->{ status > 10 }")}
      end

      describe "When built from a Hash" do
        let(:arg){ {:status => 10} }
        it{ should eq("->{ (self.status == 10) }")}
      end

      describe "When built with a singleton Array" do
        let(:arg){ ["status > 10"] }
        it{ should eq("->{ status > 10 }")}
      end

      describe "When built with a Hash-Array" do
        let(:arg){ ["status", "10"] }
        it{ should eq("->{ (self.status == 10) }")}
      end

      describe "When built with a Hash-Array without coercion" do
        let(:arg){ [:status, "10"] }
        it{ should eq("->{ (self.status == \"10\") }")}
      end

    end # TuplePredicate

    describe "on a TupleComputation" do
      let(:value){ TupleComputation.coerce(arg) }

      describe "When built from a Hash" do
        let(:arg){ {"upcased" => "status.upcase"} }
        it{ should eq("{:upcased => ->{ status.upcase }}")}
      end

    end # TupleComputation

    describe "on a Summarization" do
      let(:value){ Summarization.coerce(arg) }

      describe "When built from an Array" do
        let(:arg){ {"total" => "sum{ qty*price }"} }
        it{ should eq("{:total => sum{ qty*price }}") }
      end

    end # Summarization

    describe "on an nullary operator" do
      let(:value){ Alf::Operator::NonRelational::Generator.new([], 10, :id) } 
      it { should eq("(generator 10, :id)") }
    end

    describe "on an monadic operator with an option" do
      let(:value){ Alf::Operator::Relational::Project.new([:suppliers], [:city], :allbut => true) } 
      it { should eq("(project :suppliers, [:city], {:allbut => true})") }
    end

    describe "on an monadic operator with default values for options" do
      let(:value){ Alf::Operator::Relational::Project.new([:suppliers], [:city]) } 
      it { should eq("(project :suppliers, [:city])") }
    end

    describe "on an dyadic operator without no args nor any option" do
      let(:value){ Alf::Operator::Relational::Join.new([:suppliers, :cities]) } 
      it { should eq("(join :suppliers, :cities)") }
    end

  end
end

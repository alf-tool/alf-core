require 'spec_helper'
module Alf
  describe TupleComputation do

    describe "the class itself" do
      let(:type){ TupleComputation }
      def TupleComputation.exemplars
        [
          {:status => 10},
          {:big?   => "status > 10"}
        ].map{|x| TupleComputation.coerce(x)}
      end
      it_should_behave_like 'A valid type implementation'
    end

    it 'should have a valid example' do
      computation = TupleComputation[
        :big? => lambda{ status > 20 },
        :who  => lambda{ "#{first} #{last}" }
      ]
      res = computation.call(:last => "Jones", :first => "Bill", :status => 10)
      res.should eq(:big? => false, :who => "Bill Jones")
    end

    let(:scope){ Tools::TupleScope.new(:who => "alf") }

    describe "coerce" do

      subject{ TupleComputation.coerce(arg).evaluate(scope) }

      describe "from a TupleComputation" do
        let(:arg){ TupleComputation.new :hello => TupleExpression.coerce(:who) } 
        it{ should eql(:hello => "alf") } 
      end
        
      describe "from a Hash without coercion" do
        let(:arg){ 
          {:hello  => TupleExpression.coerce(:who),
           :hello2 => 2,
           :hello3 => lambda{ who } }
        }
        let(:expected){
          {:hello => "alf", :hello2 => 2, :hello3 => "alf"}
        }
        it{ should eql(expected) }
      end

      describe "from a Hash with coercion" do
        let(:arg){ 
          {"hello" => "who", "hello2" => "2"}
        }
        let(:expected){
          {:hello => "alf", :hello2 => 2}
        }
        it{ should eql(expected) }
      end

      describe "from an Array with coercions" do
        let(:arg){ ["hello", "who", "hello2", "2"] }
        let(:expected){
          {:hello => "alf", :hello2 => 2}
        }
        it{ should eql(expected) }
      end

    end # coerce

    describe "from_argv" do

      subject{ TupleComputation.from_argv(argv).evaluate(scope) }

      describe "from an Array with coercions" do
        let(:argv){ ["hello", "who", "hello2", "2"] }
        let(:expected){
          {:hello => "alf", :hello2 => 2}
        }
        it{ should eql(expected) }
      end

    end # from_argv

    describe "to_attr_list" do

      it 'should return the correct list of attribute names' do
        list = TupleComputation[
          :big? => lambda{ status > 20 },
          :who  => lambda{ "#{first} #{last}" }
        ].to_attr_list
        list.should be_a(AttrList)
        list.to_a.to_set.should eq([:big?, :who].to_set)
      end

    end # "to_attr_list"

  end
end

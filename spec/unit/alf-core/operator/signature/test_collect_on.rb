require 'spec_helper'
module Alf
  module Operator
    describe Signature, "#collect_on" do

      subject{ op.class.signature.collect_on(op) }
      let(:operands){  subject.first }
      let(:arguments){ subject[1]    }
      let(:options){   subject[2]    }
      
      describe "on a nullary op" do
        let(:op){ Alf.lispy.run %w{generator -- 10 -- id} } 
        it { should eq([[], [10, :id], {}]) }
      end

      describe "on a monadic op, with one arg" do
        let(:op){ Alf.lispy.run %w{autonum suppliers -- id} } 
        specify{
          operands.collect{|o| o.class}.should eq([Iterator::Proxy])
          arguments.should eq([:id])
          options.should eq({})
        }
      end

      describe "on a monadic op, with one arg and an option" do
        let(:op){ Alf.lispy.run %w{project --allbut suppliers -- name city} } 
        specify{
          operands.collect{|o| o.class}.should eq([Iterator::Proxy])
          arguments.should eq([AttrList.new([:name, :city])])
          options.should eq({:allbut => true})
        }
      end

      describe "on a dyadic op" do
        let(:op){ Alf.lispy.run %w{join suppliers cities} } 
        specify{
          operands.collect{|o| o.class}.should eq([Iterator::Proxy, Iterator::Proxy])
          arguments.should eq([])
          options.should eq({})
        }
      end

    end
  end # module Operator
end # module Alf

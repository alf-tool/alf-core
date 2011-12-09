require 'spec_helper'
module Alf
  module Operator
    describe Signature, "#collect_on" do

      subject{ op.class.signature.collect_on(op) }

      let(:operands)  { subject[0] }
      let(:arguments) { subject[1] }
      let(:options)   { subject[2] }

      describe "on a nullary op" do
        let(:op){ NonRelational::Generator.new([], 10, :id) } 
        specify { 
          subject.should eq([[], [10, :id], {}]) 
        }
      end

      describe "on a monadic op, with one arg" do
        let(:op){ NonRelational::Autonum.new([:suppliers], :id) } 
        it{ should eq([ [:suppliers], [:id], {} ]) }
      end

      describe "on a monadic op, with one arg and an option" do
        let(:op){ 
          Relational::Project.new([:suppliers], [:name, :city], :allbut => true) 
        }
        it{ should eq([[:suppliers], [AttrList[:name, :city]], {:allbut => true}]) }
      end

      describe "on a dyadic op" do
        let(:op){ Relational::Join.new([:suppliers, :cities]) }
        it{ should eq([[:suppliers, :cities], [], {}]) }
      end

    end
  end # module Operator
end # module Alf

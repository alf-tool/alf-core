require 'spec_helper'
module Alf
  module Algebra
    describe Rename, 'complete_renaming' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:op){ 
        a_lispy.rename(operand, :name => :foo)
      }

      subject{ op.complete_renaming }

      let(:expected){
        Renaming[:id => :id, :name => :foo]
      }

      it { should eq(expected) }

    end
  end
end

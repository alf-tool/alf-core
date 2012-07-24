require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Autonum, 'heading' do

      let(:operand){
        operand_with_heading(:name => String)
      }
      let(:op){ 
        parse{ autonum(operand, :auto) }
      }
      let(:expected){
        Heading[:auto => Integer, :name => String]
      }

      subject{ op.heading }

      it { should eq(expected) }

    end
  end
end

require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Clip, 'heading' do

      let(:operand){
        operand_with_heading(:id => Integer, :name => String)
      }

      subject{ op.heading }

      context '-no-allbut' do
        let(:op){ 
          parse{ clip(operand, [:id]) }
        }
        let(:expected){
          Heading[:id => Integer]
        }

        it { should eq(expected) }
      end

      context '--allbut' do
        let(:op){ 
          parse{ clip(operand, [:name], :allbut => true) }
        }
        let(:expected){
          Heading[:id => Integer]
        }

        it { should eq(expected) }
      end

    end
  end
end

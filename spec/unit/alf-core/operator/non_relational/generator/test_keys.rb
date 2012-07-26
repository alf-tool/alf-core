require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Generator, 'keys' do

      subject{ op.keys }

      let(:op){ 
        a_lispy.generator(10, :auto)
      }
      let(:expected){
        Keys[ [ :auto ] ]
      }

      it { should eq(expected) }

    end
  end
end

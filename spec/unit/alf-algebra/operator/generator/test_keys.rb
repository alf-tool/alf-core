require 'spec_helper'
module Alf
  module Algebra
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

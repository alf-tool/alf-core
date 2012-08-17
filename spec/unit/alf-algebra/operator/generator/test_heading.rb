require 'spec_helper'
module Alf
  module Algebra
    describe Generator, 'heading' do

      subject{ op.heading }

      let(:op){ 
        a_lispy.generator(10, :auto)
      }
      let(:expected){
        Heading[:auto => Integer]
      }

      it { should eq(expected) }

    end
  end
end

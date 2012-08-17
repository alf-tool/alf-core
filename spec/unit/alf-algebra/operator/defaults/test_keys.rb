require 'spec_helper'
module Alf
  module Algebra
    describe Defaults, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String).
                   with_keys([ :id ])
      }
      let(:op){ 
        a_lispy.defaults(operand, {:id => lambda{12}})
      }
      let(:expected){
        Keys[ [ :id ] ]
      }

      subject{ op.keys }

      it{ should eq(expected) }
    end
  end
end

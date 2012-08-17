require 'spec_helper'
module Alf
  module Algebra
    describe Extend, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String).
                   with_keys([ :id ], [ :name ])
      }
      subject{ op.keys }

      context "when no key is touched by extensions" do
        let(:op){ 
          a_lispy.extend(operand, :computed => lambda{ 12 })
        }

        it { should eq(Keys[ [ :id ], [ :name ] ]) }
      end

      context "when keys are touched by extensions" do
        let(:op){ 
          a_lispy.extend(operand, :name => lambda{ 12 })
        }

        it { should eq(Keys[ [ :id ] ]) }
      end

    end
  end
end

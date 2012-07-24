require 'spec_helper'
module Alf
  describe TupleComputation, 'to_heading' do

    let(:computation){
      TupleComputation[
        :big? => lambda{ status > 20 },
        :who  => lambda{ "#{first} #{last}" }
      ]
    }

    subject{ computation.to_heading }

    context 'with proper type inference' do
      it{
        pending "type inference on expressions not implemented" do
          should eq(Heading[:big? => Boolean, :who => String])
        end
      }
    end

    context 'with currenttype inference' do
      it{ should eq(Heading[:big? => Object, :who => Object]) }
    end

  end
end


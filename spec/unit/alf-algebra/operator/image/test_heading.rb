require 'spec_helper'
module Alf
  module Algebra
    describe Image, 'heading' do

      subject{ op.heading }

      let(:op){ 
        image(suppliers, supplies, :supplying)
      }

      let(:expected){
        Heading[sid: String,
                name: String,
                status: Integer,
                city: String,
                supplying: Relation[pid: String, qty: Integer]]
      }

      it{ should eq(expected) }

    end
  end
end

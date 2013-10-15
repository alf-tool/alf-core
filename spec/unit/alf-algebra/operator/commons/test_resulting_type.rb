require 'spec_helper'
module Alf
  module Algebra
    describe Operator, "resulting_type" do

      subject{ operator.resulting_type }

      context 'on an unary operator' do
        let(:operator){
          project(suppliers, [:sid, :name])
        }

        it 'returns the expected type' do
          subject.should eq(Relation[sid: String, name: String])
        end
      end

    end
  end
end

require 'spec_helper'
module Alf
  module Engine
    describe TypeCheck do

      let(:heading){ Heading.new(name: String, status: Fixnum) }
      let(:cog){ TypeCheck.new(tuples, Types::TypeCheck.new(heading, false)) }

      context 'when all valid tuples' do
        let(:tuples){
          [ {name: "Smith", status: 20}, {name: "Jones"} ]
        }

        it 'simply let the tuples pass' do
          cog.to_a.should eq(tuples)
        end
      end

      context 'when at least one invalid tuple' do
        let(:tuples){
          [ {name: "Smith", status: 20}, {name: "Jones", status: "40"} ]
        }

        it 'raises a TypeCheckError' do
          lambda{
            cog.to_a
          }.should raise_error(TypeCheckError, /Jones/)
        end
      end

    end
  end # module Engine
end # module Alf

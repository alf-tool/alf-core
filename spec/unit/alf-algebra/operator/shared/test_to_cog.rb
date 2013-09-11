require 'spec_helper'
module Alf
  module Algebra
    describe Operator, "to_cog" do

      subject{ op.to_cog }

      context 'on nullary' do
        let(:op){
          a_lispy.generator(100)
        }

        it{ should be_a(Engine::Cog) }
      end

      context 'on unary' do
        let(:op){
          a_lispy.restrict(an_operand, ->{ true })
        }

        it{ should be_a(Engine::Cog) }
      end

      context 'on binary' do
        let(:op){
          a_lispy.union(an_operand, an_operand)
        }

        it{ should be_a(Engine::Cog) }
      end

    end
  end
end

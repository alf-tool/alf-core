require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Proxy, "to_cog" do

        subject{
          proxy.to_cog
        }

        let(:proxy){
          Proxy.new(proxied)
        }

        context 'when delegable' do
          let(:proxied){
            Struct.new(:to_cog).new(:compiled)
          }

          before do
            proxied.should respond_to(:to_cog)
          end

          it{ should eq(:compiled) }
        end

        context 'when non delegable' do
          let(:proxied){
            [{a: 1}]
          }

          it{ should be_a(Engine::Leaf) }

          it 'should be the correct proxy' do
            subject.operand.should be(proxied)
          end
        end

      end
    end
  end
end

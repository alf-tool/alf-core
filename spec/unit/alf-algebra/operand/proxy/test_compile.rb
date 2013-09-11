require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Proxy, "compile" do

        subject{
          proxy.compile
        }

        let(:proxy){
          Proxy.new(proxied)
        }

        context 'when delegable' do
          let(:proxied){
            Struct.new(:compile).new(:compiled)
          }

          before do
            proxied.should respond_to(:compile)
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

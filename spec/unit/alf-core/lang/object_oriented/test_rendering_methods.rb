require 'spec_helper'
module Alf
  module Lang
    describe ObjectOriented do
      include ObjectOriented

      def _self_operand
        Relation(:name => ["Jones", "Smith", "Zurth"])
      end

      Renderer.each do |name,_,clazz|

        describe "#to_#{name}" do
          subject{ :"to_#{name}" }
          it 'should exist' do
            ObjectOriented.instance_methods.should include(subject)
          end

          it 'returns a string by default' do
            send(subject).should be_a(String)
          end

          it 'renders the values at first glance' do
            send(subject).should =~ /Zurth/
          end

          it 'returns the passed IO if any' do
            io = []
            send(subject, io).should eq(io)
          end

          it 'supports options' do
            io = []
            send(subject, {:sort => [:name]}, io).should eq(io)
          end
        end

      end
    end
  end
end
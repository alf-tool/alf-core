require 'spec_helper'
module Alf
  module Lang
    describe ObjectOriented do
      include ObjectOriented.new(supplier_names_relation)

      Renderer.each do |name,_,clazz|

        describe "#to_#{name}" do
          subject{ :"to_#{name}" }
          it 'should exist' do
            meths = ObjectOriented.instance_methods.map(&:to_sym)
            meths.should include(subject)
          end

          it 'returns a string by default' do
            send(subject).should be_a(String)
          end

          it 'renders the values at first glance' do
            send(subject).should =~ /Adams/
          end

          it 'returns the passed IO if any' do
            io = StringIO.new
            send(subject, io).should eq(io)
          end

          it 'supports options' do
            io = StringIO.new
            send(subject, {:sort => [:name]}, io).should eq(io)
          end
        end

      end
    end
  end
end

require 'spec_helper'
module Alf
  module Engine
    describe Compiler, 'unsupported' do

      def unsupported(*args, &bl)
        Compiler.new.send(:unsupported, *args, &bl)
      end

      context 'when nothing raised' do

        subject{
          unsupported(:fall){ 12 }
        }

        it 'should return the value if nothing raised' do
          subject.should eq(12)
        end
      end

      context 'when a NotSupportedError is raised' do

        subject{
          unsupported(:fall){ raise NotSupportedError }
        }

        it 'should return the fallback value' do
          subject.should eq(:fall)
        end
      end

      context 'when something else is raised' do

        subject{
          unsupported(:fall){ raise ArgumentError, "here" }
        }

        it 'should let the error be raised' do
          lambda{
            subject
          }.should raise_error(ArgumentError, "here")
        end
      end


    end
  end
end

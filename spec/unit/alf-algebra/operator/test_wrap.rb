require 'spec_helper'
module Alf
  module Algebra
    describe Wrap do

      let(:operator_class){ Wrap }

      it_should_behave_like("An operator class")


      context '--no-allbut' do
        subject{ a_lispy.wrap([], [:a, :b], :wraped) }

        it { should be_a(Wrap) }

        it 'should not be allbut' do
          subject.allbut.should be_false
        end
      end

      context '--allbut' do
        subject{ a_lispy.wrap([], [:a, :b], :wraped, :allbut => true) }

        it { should be_a(Wrap) }

        it 'should be allbut' do
          subject.allbut.should be_true
        end
      end
    end
  end
end

require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Autonum do

      let(:operator_class){ Autonum }

      it_should_behave_like("An operator class")

      context "with default attribute name" do
        subject{ a_lispy.autonum([]) }

        it{ should be_a(Autonum) }

        it 'has :autonum as attribute name' do
          subject.as.should eq(:autonum)
        end
      end # default attribute name

      context "with explicit attribute name" do
        subject{ a_lispy.autonum([], :unique) }

        it{ should be_a(Autonum) }

        it 'has :unique as attribute name' do
          subject.as.should eq(:unique)
        end
      end # explicit attribute name

    end
  end
end

require 'spec_helper'
module Alf
  module Algebra
    describe Group do

      let(:operator_class){ Group }

      it_should_behave_like("An operator class")

      context "--no-allbut" do
        subject{ a_lispy.group([], [:time, :b], :as) }

        it { should be_a(Group) }

        it 'is !allbut by default' do
          subject.allbut.should be_false
        end
      end # --no-allbut

      context "--allbut" do
        subject{ a_lispy.group([], [:a], :as, :allbut => true) }
        it { should be_a(Group) }

        it 'is allbut' do
          subject.allbut.should be_true
        end
      end # --allbut

    end
  end
end

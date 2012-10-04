require 'spec_helper'
module Alf
  module Algebra
    describe Project do

      let(:operator_class){ Project }

      it_should_behave_like("An operator class")

      context "--no-allbut" do
        subject{ a_lispy.project(an_operand, [:a]) }

        it { should be_a(Project) }

        it 'is !allbut by default' do
          subject.allbut.should be_false
        end
      end # --no-allbut

      context "--allbut" do
        subject{ a_lispy.project(an_operand, [:a], :allbut => true) }

        it { should be_a(Project) }

        it 'is allbut' do
          subject.allbut.should be_true
        end
      end # --allbut

    end
  end
end

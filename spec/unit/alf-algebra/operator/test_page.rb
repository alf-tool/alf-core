require 'spec_helper'
module Alf
  module Algebra
    describe Page do

      let(:operator_class){ Page }

      it_should_behave_like("An operator class")

      subject{
        a_lispy.page(an_operand, [[:name, :asc]], 2)
      }

      it { should be_a(Page) }

      it 'should have correct ordering' do
        subject.ordering.should eq(Ordering.coerce([[:name, :asc]]))
      end

      it 'should have correct offset' do
        subject.offset.should eq(30)
      end

    end
  end
end

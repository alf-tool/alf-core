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

      it 'should have correct page index' do
        subject.page_index.should eq(2)
      end

      it 'should have default page size' do
        subject.page_size.should eq(25)
      end

    end
  end
end

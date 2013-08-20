require 'spec_helper'
module Alf
  describe Ordering, "reverse" do

    subject{
      ordering.reverse
    }

    context 'on an empty ordering' do
      let(:ordering){ Ordering.new([]) }
      
      it{ should eq(ordering) }
    end

    context 'on a singleton asc ordering' do
      let(:ordering){ Ordering.new([[:name, :asc]]) }

      it{ should eq(Ordering.new([[:name, :desc]])) }
    end

    context 'on a singleton desc ordering' do
      let(:ordering){ Ordering.new([[:name, :desc]]) }

      it{ should eq(Ordering.new([[:name, :asc]])) }
    end

    #
    # name, id   => name, id
    #    b, 12         a, 13
    #    a, 10         a, 10
    #    a, 13         b, 12
    #
    context 'on a mixed ordering' do
      let(:ordering){ Ordering.new([[:name, :desc], [:id, :asc]]) }

      it{ should eq(Ordering.new([[:name, :asc], [:id, :desc]])) }
    end

  end # Ordering
end # Alf

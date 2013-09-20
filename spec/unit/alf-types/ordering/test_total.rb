require 'spec_helper'
module Alf
  describe Ordering, "total" do

    subject{ ordering.total(keys) }

    context 'when the ordering already covers a key' do
      let(:ordering){ Ordering[[:city, :name]] }
      let(:keys)    { Keys[[:name]]   }

      it{ should eq(ordering) }
    end

    context 'when the ordering supercovers a key' do
      let(:ordering){ Ordering[[:name, :city]] }
      let(:keys)    { Keys[[:name]]   }

      it{ should eq(ordering) }
    end

    context 'when the ordering covers no key (no overlap)' do
      let(:ordering){ Ordering[[:name, :city]] }
      let(:keys)    { Keys[[:id]]   }

      it{ should eq(Ordering[[:name, :city, :id]]) }
    end

    context 'when the ordering covers no key (with overlap)' do
      let(:ordering){ Ordering[[:name, :asc, :city, :desc]] }
      let(:keys)    { Keys[[:id, :city]]   }

      it{ should eq(Ordering[[:name, :asc, :city, :desc, :id, :asc]]) }
    end

    context 'when the keys are empty and a block' do
      let(:ordering){ Ordering[[:name, :asc, :city, :desc]] }
      let(:keys)    { Keys[]   }

      subject{ ordering.total(keys){ AttrList[:name, :city, :status] } }

      it{ should eq(Ordering[[:name, :asc, :city, :desc, :status, :asc]]) }
    end

    context 'when the keys are empty and no block' do
      let(:ordering){ Ordering[[:name, :city]] }
      let(:keys)    { Keys[]   }

      it 'should raise an error' do
        lambda{
          subject
        }.should raise_error(NotSupportedError)
      end
    end

  end
end

require 'spec_helper'
module Alf
  describe Tuple, '===' do

    let(:type){ Tuple[heading] }

    subject{ type === value }

    context 'when the exact types' do
      let(:heading){ Heading.new(name: String, status: Fixnum) }

      context 'on a valid value built with itself' do
        let(:value){ type.coerce(name: "Smith", status: 20) }

        it{ should be_true }
      end

      context 'on a valid value but built with Tuple' do
        let(:value){ Tuple.coerce(name: "Smith", status: 20) }

        it{ should be_true }
      end
    end

    context 'with a super type' do
      let(:heading){ Heading.new(name: String, status: Integer) }

      context 'on a valid value built with itself' do
        let(:value){ type.coerce(name: "Smith", status: 20) }

        it{ should be_true }
      end

      context 'on a valid value but built with Tuple' do
        let(:value){ Tuple.coerce(name: "Smith", status: 20) }

        it{ should be_true }
      end
    end

  end
end

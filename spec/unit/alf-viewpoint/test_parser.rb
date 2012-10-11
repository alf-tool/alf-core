require 'spec_helper'
module Alf
  describe Viewpoint, "parse" do

    context 'when called without connection' do
      subject{ Viewpoint.parser }

      it 'returns an unbound Lispy' do
        subject.connection.should be_nil
      end
    end

    context 'when called with a connection' do
      subject{ Viewpoint.parser(12) }

      it 'returns an bound Lispy' do
        subject.connection.should eq(12)
      end
    end

  end
end

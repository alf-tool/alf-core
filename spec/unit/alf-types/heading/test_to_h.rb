require 'spec_helper'
module Alf
  describe Heading, "to_h" do

    subject{ heading.to_h }

    after do
      subject.should eq(heading.to_hash)
    end

    context 'on an empty heading' do
      let(:heading){ Heading.new({}) }

      it{ should eq({}) }
    end

    context 'on a non-empty heading' do
      let(:heading){ Heading.new({:foo => :bar}) }

      it{ should eq({:foo => :bar}) }
    end

  end 
end

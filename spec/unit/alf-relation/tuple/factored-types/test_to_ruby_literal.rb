require 'spec_helper'
module Alf
  describe Tuple, 'to_ruby_literal' do

    let(:type){ Tuple[name: String, status: Integer] }

    subject{ type.to_ruby_literal }

    it 'should be human friendly' do
      subject.should eq("Alf::Tuple[{:name => String, :status => Integer}]")
    end

    it 'should allow eval roundtrip' do
      ::Kernel.eval(subject).should eq(type)
    end

  end
end

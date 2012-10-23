require 'spec_helper'
module Alf
  describe Relation, 'to_ruby_literal' do

    let(:reltype){ Relation[name: String, status: Integer] }

    subject{ reltype.to_ruby_literal }

    it 'should be human friendly' do
      subject.should eq("Alf::Relation[{:name => String, :status => Integer}]")
    end

    it 'should allow eval roundtrip' do
      ::Kernel.eval(subject).should eq(reltype)
    end

  end
end
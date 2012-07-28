require 'spec_helper'
module Alf
  describe Operator, "with_operands" do

    let(:operand_1) { an_operand.with_heading(:id => Integer).with_keys([:id])    }
    let(:operand_2) { an_operand.with_heading(:name => String).with_keys([:name]) }

    let(:operator) { a_lispy.project(operand_1, [:foo], :allbut => true) }

    subject{ operator.with_operands(operand_2) }

    it{ should be_a(Operator::Relational::Project) }

    before do
      operator.heading
      operator.keys
    end

    it "replaces the operands but keeps params unchanged" do
      subject.operands.first.should be(operand_2)
      subject.attributes.should eq(AttrList[:foo])
      subject.allbut.should be_true
    end

    it "keeps the original unchanged" do
      operator.operands.first.should be(operand_1)
      subject.attributes.should eq(AttrList[:foo])
      subject.allbut.should be_true
    end

    it 'does not keep computed heading from the original' do
      subject.heading.should eq(Heading.coerce(:name => String))
    end

    it 'does not keep computed keys from the original' do
      subject.keys.should eq(Keys[ [:name] ])
    end

  end
end

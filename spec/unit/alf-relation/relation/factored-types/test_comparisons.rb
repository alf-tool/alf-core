require 'spec_helper'
module Alf
  describe Relation, '<=>' do

    let(:type)     { Relation[name: String, status: Integer] }
    let(:supertype){ Relation[name: String, status: Numeric] }
    let(:subtype)  { Relation[name: String, status: Fixnum]  }

    subject{ type <=> other }

    context 'on something else' do
      let(:other){ Integer }

      it{ should be_nil }
    end

    context 'on itself' do
      let(:other){ type }

      it{ should eq(0) }
    end

    context 'on same type' do
      let(:other){ Relation[name: String, status: Integer] }

      it{ should eq(0) }
    end

    context 'on a sub type' do
      let(:other){ subtype }

      it{ should eq(1) }
    end

    context 'on a super type' do
      let(:other){ supertype }

      it{ should eq(-1) }
    end

    context 'the shortcuts' do

      it 'the > shortcut classifies correctly' do
        (supertype > supertype).should be_false
        (supertype > type).should be_true
        (supertype > subtype).should be_true
      end

      it 'the >= shortcut classifies correctly' do
        (supertype >= supertype).should be_true
        (supertype >= type).should be_true
        (supertype >= subtype).should be_true
      end

      it 'the < shortcut classifies correctly' do
        (supertype < supertype).should be_false
        (supertype < type).should be_false
        (supertype < subtype).should be_false
      end

      it 'the <= shortcut classifies correctly' do
        (supertype <= supertype).should be_true
        (supertype <= type).should be_false
        (supertype <= subtype).should be_false
      end
    end

  end
end
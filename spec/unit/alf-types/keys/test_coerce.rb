require 'spec_helper'
module Alf
  describe Keys, ".coerce" do

    subject{ Keys.coerce(arg) }

    let(:expected){ Keys.new [ AttrList[:id], AttrList[:name] ] }

    context 'on a Keys' do
      let(:arg){ expected }

      it{ should be(arg) }
    end

    context 'on an Array of AttrList coercables' do
      let(:arg){ [ [:id], [:name] ] }

      it{ should eq(expected) }
    end
  end
  describe Keys, "[]" do

    let(:expected){ Keys.new [ AttrList[:id], AttrList[:name] ] }

    context 'on a varargs with arrays of symbols' do
      subject{ Keys[ [:id], [:name] ] }

      it{ should eq(expected) }
    end

    context 'on [:a, :b]' do
      subject{ Keys[ [:a, :b] ] }

      it 'should have correct AttrList lists' do
        subject.to_a.should eq([ AttrList[:a, :b] ])
      end
    end

    context 'on empty' do
      subject{ Keys[] }

      it 'should have correct AttrList lists' do
        subject.to_a.should eq([])
      end
    end

    context 'on one empty list' do
      subject{ Keys[ [] ] }

      it 'should have correct AttrList lists' do
        subject.to_a.should eq([ AttrList[] ])
      end
    end

    context 'at least one empty list' do
      subject{ Keys[ [:a], [] ] }

      it 'should have correct AttrList lists' do
        subject.to_a.should eq([ AttrList[:a], AttrList[] ])
      end
    end

  end
end
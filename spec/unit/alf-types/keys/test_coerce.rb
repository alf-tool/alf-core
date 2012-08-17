require 'spec_helper'
module Alf
  describe Keys, ".coerce" do

    subject{ Keys.coerce(arg) }

    context 'on a Keys' do
      let(:arg){ Keys.new [] }

      it{ should be_a(Keys) }
      it{ should be(arg)    }
    end

    context 'on an Array of AttrList coercables' do
      let(:arg){ [ [:id], [:name] ] }

      it{ should be_a(Keys) }

      it 'should have expected AttLists' do
        subject.keys.should eq([ AttrList[:id], AttrList[:name] ])
      end
    end

    it 'is available through [] with varargs' do
      keys = Keys[ [:id], [:name] ]
      keys.should be_a(Keys)
      keys.keys.should eq([ AttrList[:id], AttrList[:name] ])
    end

  end
end
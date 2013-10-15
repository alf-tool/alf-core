require 'spec_helper'
module Alf
  describe Relation, '.dum' do

    let(:type){ Relation[name: String, status: Integer] }

    subject{ type.dum }

    it 'returns a Relation' do
      subject.should be_a(type)
      subject.should be_a(Relation)
    end

    it 'is empty' do
      subject.should be_empty
    end

  end
end

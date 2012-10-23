require 'spec_helper'
module Alf
  describe Relation, '.rename' do

    let(:type){ Relation[name: String, status: Integer] }

    subject{ type.rename(name: :first_name) }

    it{ should eq(Relation[first_name: String, status: Integer]) }

  end
end

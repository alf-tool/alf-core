require 'spec_helper'
module Alf
  describe Tuple, 'rename' do

    let(:type){ Tuple[name: String, status: Integer] }

    subject{ type.rename(name: :first_name) }

    it{ should eq(Tuple[first_name: String, status: Integer]) }

  end
end

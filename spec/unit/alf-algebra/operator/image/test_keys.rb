require 'spec_helper'
module Alf
  module Algebra
    describe Image, 'keys' do

      subject{ op.keys }

      let(:op){ 
        a_lispy.image(suppliers, supplies, :supplying)
      }

      it{ should eq(Keys[[:sid], [:name]]) }

    end
  end
end

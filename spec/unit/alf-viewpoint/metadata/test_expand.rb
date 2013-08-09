require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, ".reduce" do

      subject{ metadata.expand }

      let(:metadata) do 
        @base  = base  = viewpoint{ }
        @user  = user  = viewpoint{ expects(base) }
        @util1 = util1 = viewpoint{ expects(base); depends(:user, user) }
        @util2 = util2 = viewpoint{ expects(util1); depends(:user, user) }
        @term  = viewpoint{ expects(util2) }
        @term.metadata
      end

      it 'should be a Metadata' do
        subject.should be_a(Metadata)
      end

      it 'should have expected expectations' do
        subject.expectations.should eq([ @base, @util1, @util2 ])
      end

      it 'should have expected dependencies' do
        subject.dependencies.should eq(user: [ @user ])
      end

    end
  end
end

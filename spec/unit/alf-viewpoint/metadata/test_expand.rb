require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, ".reduce" do

      subject{ metadata.expand }

      let(:metadata) do 
        @base  = base = viewpoint{ }
        @user  = user = viewpoint{ expects(base) }
        @util1 = util = viewpoint{ expects(base); depends(:user, user) }
        @util2 = viewpoint{ expects(base); depends(:user, user) }
        @term  = viewpoint{ expects(util) }
        @term.metadata
      end

      it 'should be a Metadata' do
        subject.should be_a(Metadata)
      end

      it 'should have expected expectations' do
        subject.expectations.should eq([ @base, @util1 ])
      end

      it 'should have expected dependencies' do
        subject.dependencies.should eq(user: [ @user ])
      end

    end
  end
end

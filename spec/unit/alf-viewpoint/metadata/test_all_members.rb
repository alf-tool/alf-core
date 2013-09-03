require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, "all_members" do

      let(:metadata) do 
        @base  = base  = viewpoint{ native :base }
        @user  = user  = viewpoint{ expects(base); native :user }
        @util1 = util1 = viewpoint{ expects(base);  depends(:user, user) }
        @util2 = util2 = viewpoint{ expects(util1); depends(:user, user) }
        @term  = viewpoint{ expects(util2) }
        @term.metadata
      end

      before do
        metadata
      end

      context 'on base' do
        subject{ @base.metadata.all_members }

        it{ should eq([:base]) }
      end

      context 'on user' do
        subject{ @user.metadata.all_members }

        it{ should eq([:base, :user]) }
      end

    end
  end
end

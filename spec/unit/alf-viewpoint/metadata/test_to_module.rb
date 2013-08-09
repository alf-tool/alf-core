require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, "#to_module" do

      subject{ metadata.to_module }

      let(:metadata) do 
        @base  = base = viewpoint{ }
        @user  = user = viewpoint{ expects(base) }
        @util1 = util = viewpoint{ expects(base); depends(:user, user) }
        @util2 = viewpoint{ expects(base); depends(:user, user) }
        @term  = viewpoint{ expects(util) }
        @term.metadata
      end

      it 'should be a Module' do
        subject.should be_a(Module)
      end

      it 'should include Alf::Viewpoint' do
        subject.should include(Alf::Viewpoint)
      end

      it 'should include util1' do
        subject.should include(@util1)
      end

      it 'should have a user method' do
        lambda{
          subject.parser.user
        }.should_not raise_error
      end

    end
  end
end

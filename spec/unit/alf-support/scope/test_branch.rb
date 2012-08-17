require 'spec_helper'
module Alf
  module Support
    describe Scope, '__branch' do

      let(:scope) { Scope.new [ HelpersInScope ] }

      subject{ scope.__branch(arg) }

      context 'when branched with a Tuple' do
        let(:arg){ {:here => "here"} }

        it_behaves_like 'A scope'

        it 'responds to the tuple keys' do
          subject.respond_to?(:here).should be_true
          subject.here.should eq("here")
        end

        it "responds to helper's methods" do
          subject.respond_to?(:world).should be_true
          subject.world.should eq('world')
        end
      end

    end
  end
end
require 'spec_helper'
module Alf
  module Operator
    describe VarRef, "heading" do

      let(:context){ Object.new.extend Module.new{
        def connection
          self
        end
        def heading(name)
          {:name => String}
        end
      }}
      let(:var_ref){ VarRef.new(context, :suppliers) }

      subject { var_ref.heading }

      it 'delegates the call to the context' do
        subject.should eq(:name => String)
      end

    end
  end
end

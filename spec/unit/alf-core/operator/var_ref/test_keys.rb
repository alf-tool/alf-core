require 'spec_helper'
module Alf
  module Operator
    describe VarRef, "keys" do

      let(:context){ Object.new.extend Module.new{
        def relvar(name)
          raise unless name == :suppliers
          Struct.new(:keys).new([:foo])
        end
      }}
      let(:var_ref){ VarRef.new(context, :suppliers) }

      subject { var_ref.keys }

      it 'delegates the call to the context' do
        subject.should eq([:foo])
      end

    end
  end
end

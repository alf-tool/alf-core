require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_relation" do

      let(:rv)        { Base.new(connection, :suppliers) }
      let(:connection){ self                             }

      def cog(*args)
        Struct.new(:to_relation).new("a relation")
      end

      subject{ rv.to_relation }

      it 'delegates to the cog' do
        subject.should eq("a relation")
      end

    end
  end
end

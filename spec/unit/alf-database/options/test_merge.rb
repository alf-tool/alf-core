require 'spec_helper'
module Alf
  class Database
    describe Options, "merge" do

      let(:opts){ Options.new(schema_cache: true) }

      subject{ opts.merge(schema_cache: false) }

      it{ should be_a(Options) }

      it 'is not the original' do
        subject.should_not be(opts)
      end

      it 'merges the new options' do
        subject.schema_cache?.should eq(false)
      end

      it 'does not touch the original' do
        opts.schema_cache?.should eq(true)
      end

    end
  end
end

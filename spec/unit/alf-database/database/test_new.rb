require 'spec_helper'
module Alf
  describe Database, '.new' do

    let(:adapter){ Adapter.new(nil) }

    after do
      subject.adapter.should be_a(Adapter)
    end

    context 'on a single adapter' do
      subject{ Database.new(adapter) }

      it 'uses the specified adapter' do
        subject.adapter.should be(adapter)
      end

      it 'uses default options' do
        subject.schema_cache?.should be_true
      end
    end

    context 'on an adapter to be coerced' do
      subject{ Database.new(Path.dir) }

      it 'coerces the adapter' do
        subject.adapter.should be_a(Adapter::Folder)
      end

      it 'uses default options' do
        subject.schema_cache?.should be_true
      end
    end

    context 'when passing options' do
      subject{ Database.new(adapter, schema_cache: false) }

      it 'set the options correctly' do
        subject.schema_cache?.should be_false
      end
    end

    context 'when a block is given' do
      subject{ Database.new(adapter){|d| @seen = d } }

      it 'yields the block' do
        subject
        @seen.should be(subject)
      end
    end

  end
end

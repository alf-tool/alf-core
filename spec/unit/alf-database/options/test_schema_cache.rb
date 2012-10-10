require 'spec_helper'
module Alf
  class Database
    describe Options, "schema_cache?" do

      subject{ opts.schema_cache? }

      let(:opts){ Options.new }

      context 'by default' do

        it { should eq(true) }
      end

      context 'when explicitely set' do
        before{ opts.schema_cache = false }

        it{ should eq(false) }
      end

      context 'when explicitely set but coercion needed' do
        before{ opts.schema_cache = "false" }

        it{ should eq(false) }
      end

    end
  end
end

require 'spec_helper'
module Alf
  class Database
    describe Options, "freeze" do

      let(:opts){ Options.new(schema_cache: true) }

      subject{ opts.freeze }

      it{ should be(opts) }

      it 'should prevent further modifications' do
        lambda{
          subject.schema_cache = false
        }.should raise_error(/can't modify frozen/)
      end

    end
  end
end

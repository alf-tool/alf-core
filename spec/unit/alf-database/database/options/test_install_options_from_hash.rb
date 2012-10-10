require 'spec_helper'
module Alf
  class Database
    describe Options, "install_options_from_hash" do
      include Options

      let(:viewpoint){ Module.new{ include Viewpoint } }

      subject{ install_options_from_hash(h) }

      context 'when valid, coercable options' do
        let(:h){ {schema_cache: "false", default_viewpoint: viewpoint} }

        it 'sets the options as expected' do
          subject
          schema_cache?.should eq(false)
          default_viewpoint.should be(viewpoint)
        end
      end

      context 'when an option is not known' do
        let(:h){ {nosuchone: "blah"} }

        it 'raises an error' do
          lambda{
            subject
          }.should raise_error(DatabaseOptionError, /No such database option `nosuchone`/)
        end
      end

      context 'when an option cannot be coerced' do
        let(:h){ {schema_cache: "blah"} }

        it 'raises an error' do
          lambda{
            subject
          }.should raise_error(DatabaseOptionError, /Invalid option value `schema_cache`: `blah`/)
        end
      end

      attr_writer :hello_world

      context 'when trying to cheat' do
        let(:h){ {hello_world: "blah"} }

        it 'raises an error' do
          lambda{
            subject
          }.should raise_error(DatabaseOptionError, /No such database option `hello_world`/)
        end
      end

    end
  end
end

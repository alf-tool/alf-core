require 'spec_helper'
module Alf
  describe Database, 'default_options' do

    subject{ Database.new(Path.dir) }

    it_should_behave_like "a facade on database options"

    it 'should allow default options to be consulted' do
      subject.default_options.should be_a(Database::Options)
    end

  end
end

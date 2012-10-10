require 'spec_helper'
module Alf
  describe Database, 'connection' do

    let(:db){ Database.new(Path.dir) }

    subject{ db.connection }

    after do
      subject.close
    end

    it{ should be_a(Database::Connection) }

    it 'sets a copy of the original options' do
      subject.options.should be_a(Database::Options)
      subject.options.should_not be(db.default_options)
    end

  end
end
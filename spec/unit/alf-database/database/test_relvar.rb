require 'spec_helper'
module Alf
  describe Database, '.relvar' do

    let(:db_class){ Class.new(Database) }

    subject{ db_class.relvar(:suppliers) }

    it 'installs the relvar on the public schema' do
      subject
      lambda{
        db_class.schema(:public).instance_method(:suppliers)
      }.should_not raise_error(NameError)
    end

  end
end
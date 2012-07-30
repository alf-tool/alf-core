require 'spec_helper'
module Alf
  describe Database, '.relvar' do

    let(:db_class){ Class.new(Database) }

    subject{ db_class.relvar(:suppliers) }

    it 'installs the relvar on the default schema' do
      subject
      lambda{
        db_class.default_schema.instance_method(:suppliers)
      }.should_not raise_error(NameError)
    end

    it 'does not touch superclass default schema' do
      subject
      lambda{
        Database.default_schema.instance_method(:suppliers)
      }.should raise_error(NameError)
    end

  end
end
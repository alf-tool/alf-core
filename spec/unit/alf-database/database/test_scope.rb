require 'spec_helper'
module Alf
  describe Database, 'scope' do

    let(:db_class){ 
      Class.new(Database){ 
        helpers{ def foo; end } 
        schema(:test_schema){}
      } 
    }
    let(:db){ db_class.new(Connection.folder('.')) }

    subject{ db.scope }

    it 'has algebra methods' do
      subject.respond_to?(:matching).should be_true
    end

    it 'has installed helpers' do
      subject.respond_to?(:foo).should be_true
    end

    it 'has installed schemas' do
      subject.respond_to?(:test_schema).should be_true
      subject.respond_to?(:native).should be_true
    end

  end
end
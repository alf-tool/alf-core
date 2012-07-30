require 'spec_helper'
module Alf
  describe Database, 'scope' do

    let(:db_class){ 
      Class.new(Database){ 
        helpers{ def foo; end } 
      } 
    }
    let(:db){ db_class.new(Connection.folder('.')) }

    let(:helpers){
      Module.new{ def bar; end }
    }

    subject{ db.scope([helpers]) }

    it 'has algebra methods' do
      subject.respond_to?(:matching).should be_true
    end

    it 'has installed helpers' do
      subject.respond_to?(:foo).should be_true
      subject.respond_to?(:bar).should be_true
    end

  end
end
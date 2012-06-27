require 'spec_helper'
module Alf
  class Relvar
    describe Base, 'value' do

      let(:db)      { examples_database           }
      let(:name)    { :suppliers                  }
      let(:builder) { lambda{|ctx| [{:id => 1}] } }
      let(:relvar)  { Base.new(db,name,&builder)  }

      subject{ relvar.value }

      it 'is obtained through the bulder' do
        subject.should eq(Relation(:id => 1))
      end

    end
  end
end
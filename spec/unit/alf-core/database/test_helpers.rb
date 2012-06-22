require 'spec_helper'
module Alf
  describe Database, '.helpers' do

    subject{ db.helpers }

    after do
      subject.all?{|m| m.is_a?(Module) }.should be_true
    end

    context 'on Database itself' do
      let(:db){ Database }

      it 'should have 3 modules' do
        subject.size.should eq(3)
      end
    end

    context 'when subclassing' do
      let(:db){ Class.new(Database){ helpers HelpersInScope } }

      it 'has 4 modules, with HelpersInScope as last one' do
        subject.size.should eq(4)
        subject.last.should 
      end

      it 'does not touch Database itself' do
        Database.helpers.size.should eq(3)
        Database.helpers.should_not include(HelpersInScope)
      end
    end

    context 'when invoked with a block' do
      let(:db){ 
        Class.new(Database){ 
          helpers{ def a_helper_method; end; }
        }
      }
      it 'has 4 modules' do
        subject.size.should eq(4)
      end
      it 'has helping methods on the last module' do
        subject.last.instance_methods.map(&:to_sym).should include(:a_helper_method)
      end
    end

  end # Database, '.helpers'
end # module Alf
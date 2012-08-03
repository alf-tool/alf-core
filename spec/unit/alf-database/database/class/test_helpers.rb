require 'spec_helper'
module Alf
  describe Database, '.helpers' do

    subject{ db.helpers }

    after do
      subject.all?{|m| m.is_a?(Module) }.should be_true
    end

    context 'on Database itself' do
      let(:db){ Database }

      it 'should have 0 modules' do
        subject.size.should eq(0)
      end
    end

    context 'when subclassing' do
      let(:db){ Class.new(Database){ helpers HelpersInScope } }

      it 'has 1 module, HelpersInScope' do
        subject.size.should eq(1)
        subject.last.should be(HelpersInScope)
      end

      it 'does not touch Database itself' do
        Database.helpers.size.should eq(0)
      end
    end

    context 'when invoked with a block' do
      let(:db){ 
        Class.new(Database){ 
          helpers{ def a_helper_method; end; }
        }
      }
      it 'has 1 modules' do
        subject.size.should eq(1)
      end
      it 'has helping methods on the last module' do
        subject.last.instance_methods.map(&:to_sym).should include(:a_helper_method)
      end
    end

  end # Database, '.helpers'
end # module Alf
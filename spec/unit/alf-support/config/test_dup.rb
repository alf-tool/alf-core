require 'spec_helper'
module Alf
  module Support
    describe Config, 'dup' do

      let(:conf_subclass){
        Class.new(Config){
          option :ready, Boolean, false
          option :preferences, Array, []
          option :aproc, Boolean, ->{ !ready? }
        }
      }

      let(:config){ conf_subclass.new }

      context 'when not freezed' do
        subject{ config.dup }

        it 'should return a different instance' do
          subject.should be_a(conf_subclass)
          subject.should_not be(config)
        end

        it 'should dup all options while keeping them equal' do
          conf_subclass.options.each do |name,_,_|
            mine, yours = subject[name], config[name]
            mine.should eq(yours)
            mine.should_not be(yours) unless Boolean===mine
          end
        end

        it 'should keep the semantics of Proc options' do
          subject.aproc?.should be_true
          subject.ready = true
          subject.aproc?.should be_false
        end
      end

      context 'when frozen' do
        subject{ config.freeze.dup }

        it 'should return a non-frezed instance' do
          subject.should be_a(conf_subclass)
          subject.should_not be_frozen
        end

        it 'allow modifying options on the new instance' do
          lambda{
            subject.ready = true
          }.should_not raise_error
          subject.ready?.should be_true
          config.ready?.should be_false
        end
      end

    end
  end
end

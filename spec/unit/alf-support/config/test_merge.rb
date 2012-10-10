require 'spec_helper'
module Alf
  module Support
    describe Config, "merge" do

      let(:config_class){
        Class.new(Config){ 
          option :ready, Boolean, true
          option :hello, String, "world"
        }
      }
      let(:config){ config_class.new }

      subject{ config.merge(ready: false) }

      it{ should be_a(config_class) }

      it 'is not the original' do
        subject.should_not be(config)
      end

      it 'merges the new options' do
        subject.ready?.should eq(false)
        subject.hello.should eq("world")
      end

      it 'does not touch the original' do
        config.ready?.should eq(true)
        config.hello.should eq("world")
      end

    end
  end
end

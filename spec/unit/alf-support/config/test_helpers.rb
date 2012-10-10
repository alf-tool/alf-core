require 'spec_helper'
module Alf
  module Support
    describe Config, "helpers" do

      let(:config_class){
        Class.new(Config){ 
          option :ready, Boolean, true
          option :hello, String, "world"
        }
      }

      subject{ config_class.helpers(:a_config) }

      it { should be_a(Module) }

      context 'when included in an object' do
        let(:obj){
          Struct.new(:a_config).new(config_class.new)
        }

        before do
          obj.extend(subject)
        end
        
        it 'delegates when included in an object' do
          obj.ready?.should eq(true)
        end
      end

    end
  end
end

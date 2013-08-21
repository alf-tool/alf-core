require 'spec_helper'
module Alf
  module Support
    describe Config, '[]=' do

      let(:conf_subclass){
        Class.new(Config){
          option :ready, Boolean, false
          option :preferences, Array, ["foo"]
        }
      }

      let(:config){ conf_subclass.new }

      subject{ config[attr] = value }

      context 'on a boolean' do
        let(:attr){ :ready }
        let(:value){ true }

        it 'should return the value' do
          subject.should eq(value)
        end

        it 'should set the value' do
          subject
          config.ready?.should eq(true)
        end
      end

      context 'on a non boolean' do
        let(:attr){ :preferences }
        let(:value){ ["bar"] }

        it 'should return the value' do
          subject.should eq(value)
        end

        it 'should set the value' do
          subject
          config.preferences.should eq(["bar"])
        end
      end

      context 'when used for merging arrays' do
        let(:attr){ :preferences }
        let(:value){ ["bar"] }

        subject{
          config[:preferences] |= value
        }

        it 'should merge the values' do
          subject
          config.preferences.should eq(["foo", "bar"])
        end
      end

    end
  end
end

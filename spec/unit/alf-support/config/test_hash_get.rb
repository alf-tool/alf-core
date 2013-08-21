require 'spec_helper'
module Alf
  module Support
    describe Config, '[]' do

      let(:conf_subclass){
        Class.new(Config){
          option :ready, Boolean, false
          option :preferences, Array, ["foo"]
        }
      }

      let(:config){ conf_subclass.new }

      subject{ config[attr] }

      context 'on a boolean' do
        let(:attr){ :ready }

        it{ should eq(false) }
      end

      context 'on a non-boolean' do
        let(:attr){ :preferences }

        it{ should eq(["foo"]) }
      end

      context 'after being set' do
        let(:attr){ :preferences }

        before do
          config.preferences = ["bar"]
        end

        it{ should eq(["bar"]) }
      end

    end
  end
end

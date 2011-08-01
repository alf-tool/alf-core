require 'spec_helper'
module Alf
  module Tools
    describe Signature, '.initialize' do

      it "should yield the signature" do
        sig = Signature.new{|s|
          s.argument :name, AttrName, :autonum
        }
        sig.arguments.should eql([[:name, AttrName, :autonum]])
      end

    end
  end
end

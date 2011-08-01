require 'spec_helper'
module Alf
  module Tools
    describe Signature, '.initialize' do

      it "should yield the signature" do
        sig = Signature.new{|s|
          s.argument :name, AttrName, :autonum
          s.option :allbut, Boolean, true
        }
        sig.arguments.should eql([[:name, AttrName, :autonum]])
        sig.options.should eql([[:allbut, Boolean, true]])
      end

    end
  end
end

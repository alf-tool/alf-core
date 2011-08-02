require 'spec_helper'
module Alf
  module Tools
    describe Signature, '.initialize' do

      it "should yield the signature" do
        sig = Signature.new{|s|
          s.argument :name, AttrName, :autonum
          s.descr "Applies an allbut projection?"
          s.option :allbut, Boolean, true
        }
        sig.arguments.should eql([[:name, AttrName, :autonum, nil]])
        sig.options.should eql([[:allbut, Boolean, true, "Applies an allbut projection?"]])
      end

    end
  end
end

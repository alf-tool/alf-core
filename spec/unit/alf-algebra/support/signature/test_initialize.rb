require 'spec_helper'
module Alf
  module Algebra
    describe Signature, '.initialize' do

      subject{
        Signature.new(nil){|s|
          s.argument :name, AttrName, :autonum
          s.option :allbut, Boolean, true, "Applies an allbut projection?"
        }        
      }

      it "yields the signature" do
        subject.arguments.should eql([[:name, AttrName, :autonum, nil]])
        subject.options.should eql([[:allbut, Boolean, true, "Applies an allbut projection?"]])
      end

    end
  end
end

require 'spec_helper'
require 'alf/logs'
module Alf
  describe Logs::Reader do
    
    let(:input){ _("apache_combined.log", __FILE__) }
    let(:reader){ Logs::Reader.new(input) }
    
    it "should yield a pseudo-relation" do
      reader.all?{|tuple| tuple.is_a?(Hash)}.should be_true
    end
     
  end
end
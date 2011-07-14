require 'spec_helper'
module Alf
  describe Logs::Reader do
    
    let(:input){ _("apache_combined.log", __FILE__) }
    
    describe "when called on a reader directly" do
      let(:reader){
        ::Alf::Logs::Reader.new(input)
      }
      it "should yield a pseudo-relation" do
        reader.all?{|tuple| tuple.is_a?(Hash)}.should be_true
      end
    end
    
    describe "when called through registered one" do
      let(:reader){
        ::Alf::Reader.reader(input)
      }
      specify{ reader.should be_a(::Alf::Logs::Reader) }
      it "should yield a pseudo-relation" do
        reader.all?{|tuple| tuple.is_a?(Hash)}.should be_true
      end
    end
    
    describe "when called through factory method" do
      let(:reader){
        ::Alf::Reader.logs(input)
      }
      specify{ reader.should be_a(::Alf::Logs::Reader) }
      it "should yield a pseudo-relation" do
        reader.all?{|tuple| tuple.is_a?(Hash)}.should be_true
      end
    end

  end
end
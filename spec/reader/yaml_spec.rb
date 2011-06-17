require 'spec_helper'
module Alf
  describe Reader::YAML do

    let(:io){ StringIO.new tuples.to_yaml }
    let(:reader){ Reader::YAML.new(io) } 
    subject{ reader.to_a }

    describe "when applied to an array" do
      let(:tuples){ [{:status => 10},{:status => 30}] } 
      it{ should == tuples }
    end
      
    describe "when applied to a hash" do
      let(:tuples){ {:status => 10} } 
      it{ should == [tuples]}
    end
      
  end
end
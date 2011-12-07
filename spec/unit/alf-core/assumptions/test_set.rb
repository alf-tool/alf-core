require 'spec_helper'
require 'set'
describe Set do
  
  specify "empty sets should be equal" do
    Set.new([]).should eq(Set.new([]))
    Set.new([]).should eql(Set.new([]))
  end
  
  describe "on DEE-like sets" do
    let(:dee){ Set.new([{}]) }
      
    specify "DEE sets should be equal" do
      Set.new([{}]).should eq(dee)
      Set.new([{}]).should eql(dee)
    end
    
    specify "DEE-like sets should be equal (1)" do
      arr = [{}]
      Set.new(arr).should eq(dee)
      Set.new(arr).should eql(dee)
    end
    
    specify "DEE-like sets should be equal (2)" do
      arr = [{}]
      Set.new(arr.to_a).should eq(dee)
      Set.new(arr.to_a).should eql(dee)
    end
    
    specify "DEE-like sets should be equal (3)" do
      arr = [{}]
      arr.to_set.should eq(dee)
      arr.to_set.should eql(dee)
    end
    
    specify "DEE-like sets should be equal (4)" do
      arr = [{}]
      arr.to_set.should eq(dee)
      arr.to_set.should eql(dee)
    end
    
    specify "DEE-like sets should be equal (5)" do
      arr = Object.new.extend(Enumerable)
      def arr.each
        yield({})
      end
      arr.to_set.should eq(dee)
      arr.to_set.should eql(dee)
    end
    
    specify "DEE-like sets should be equal (5)" do
      arr = Object.new.extend(Enumerable)
      def arr.each
        tuple = {:sid => "1"} 
        tuple.delete(:sid)
        yield(tuple)
      end
      arr.to_set.should eq(dee)
      arr.to_set.should eql(dee)
    end

  end  

end
require 'spec_helper'
module Alf
  module Tools
    describe "Summarization" do
      
      describe "coerce" do
      
        subject{ Summarization.coerce(arg) }
        
        describe "from a Summarization" do
          let(:arg){ Summarization.new(:s => Aggregator.sum(:qty)) }
          it{ should eq(arg) }
        end
        
        describe "from a Hash" do
          let(:arg){ { :s => "sum(:qty)", :m => Aggregator.max(:size) } }
          it{ should be_a(Summarization) }
          specify{ 
            subject.aggregations.values.all?{|v|
              v.is_a?(Aggregator)
            }.should be_true
          }
        end
        
        describe "from an Array" do
          let(:arg){ ["s", "sum(:qty)", "m", "max(:size)"] }
          it{ should be_a(Summarization) }
          specify{ 
            ([:s, :m] & subject.aggregations.keys).should eq([:s, :m]) 
            subject.aggregations.values.all?{|v|
              v.is_a?(Aggregator)
            }.should be_true
          }
        end
          
      end
      
      specify "least -> happens -> finalize" do
        summ = Summarization.coerce(["s", "sum(:qty)", "m", "max(:size)"])
        (x = summ.least).should eql(:s => 0, :m => nil)
        (x = summ.happens(x, :qty => 10, :size => 12)).should eq(:s => 10, :m => 12)
        (x = summ.happens(x, :qty => 5, :size => 5)).should eq(:s => 15, :m => 12)
        summ.finalize(x).should eq(:s => 15, :m => 12)
      end
      
    end
  end
end
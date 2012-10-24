require 'spec_helper'
module Alf
  class Reader
    describe CSV do
    
      describe "without options" do
        let(:input){ 
          StringIO.new << "size\n10\n20\n"
        }
        let(:expected){
          [{:size => "10"}, {:size => "20"}]
        }
        subject{ reader.to_a }
          
        describe "when called on a reader directly" do
          let(:reader){
            CSV.new(input)
          }
          it{ should eq(expected) }
        end
        
        describe "when called through registered one" do
          let(:reader){
            Reader.reader(Path.dir / 'input.csv')
          }
          it{ should eq(expected) }
        end
        
        describe "when called through factory method" do
          let(:reader){
            Reader.csv(input)
          }
          it{ should eq(expected) }
        end
      end
      
      describe "with options" do
        let(:input){ 
          StringIO.new << "size;name\n10;blambeau\n20;mmathieu\n"
        }
        let(:options){
          {:col_sep => ";"}
        }
        let(:expected){
          [{:size => "10", :name => 'blambeau'}, {:size => "20", :name => 'mmathieu'}]
        }
        subject{ reader.to_a }
          
        describe "when called on a reader directly" do
          let(:reader){
            CSV.new(input, options)
          }
          it{ should eq(expected) }
        end
        
        describe "when called through factory method" do
          let(:reader){
            Reader.csv(input, options)
          }
          it{ should eq(expected) }
        end
      end
      
    end
  end
end
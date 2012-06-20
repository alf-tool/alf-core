require 'spec_helper'
module Alf
  module CSV
    describe Renderer do
    
      describe "without options" do
        let(:input){ 
          [{:size => 10}, {:size => 20}]
        }
        let(:expected){
          "size\n10\n20\n"
        }
        subject{ renderer.execute(StringIO.new).string }
          
        describe "when called on a renderer directly" do
          let(:renderer){
            ::Alf::CSV::Renderer.new(input)
          }
          it{ should eq(expected) }
        end
        
        describe "when called through registererd one" do
          let(:renderer){
            ::Alf::Renderer.renderer(:csv, input)
          }
          it{ should eq(expected) }
        end
        
        describe "when called through factory method" do
          let(:renderer){
            ::Alf::Renderer.csv(input)
          }
          it{ should eq(expected) }
        end
      end
      
      describe "with options", :ruby19 => true do
        let(:input){ 
          [{:size => 10, :name => "blambeau"}, {:size => 20, :name => "mmathieu"}]
        }
        let(:expected){
          "size;name\n10;blambeau\n20;mmathieu\n"
        }
        let(:options){
          {:col_sep => ";"}
        }
        subject{ renderer.execute(StringIO.new).string }
          
        describe "when called on a renderer directly" do
          let(:renderer){
            ::Alf::CSV::Renderer.new(input, options)
          }
          it{ should eq(expected) }
        end
        
        describe "when called through registererd one" do
          let(:renderer){
            ::Alf::Renderer.renderer(:csv, input, options)
          }
          it{ should eq(expected) }
        end
        
        describe "when called through factory method" do
          let(:renderer){
            ::Alf::Renderer.csv(input, options)
          }
          it{ should eq(expected) }
        end
      end
      
    end
  end
end
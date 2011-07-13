require 'spec_helper'
module Alf
  module CSV
    describe Renderer do
    
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
  end
end
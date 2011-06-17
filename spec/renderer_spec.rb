require File.expand_path('../spec_helper', __FILE__)
module Alf
  describe Renderer do
    
    subject{ Renderer }
    it { should respond_to(:rash) }
    it { should respond_to(:text) }

    describe "renderer_names" do
      subject{ Renderer.renderer_names }
      it{ should include(:rash) }
      it{ should include(:text) }
    end
    
    describe "renderer_by_name" do
      subject{ Renderer.renderer_by_name(:text) }
      it{ should == Renderer::Text } 
    end
          
    describe 'rash' do
      subject{ Renderer.rash(input, output) } 
      let(:input){ [{:a => 1}] }
      let(:output){ "" }
      let(:expected){ "{:a=>1}\n" }
      it{ should == expected }
    end
    
    describe 'text' do
      subject{ Renderer.text(input, output) } 
      let(:input){ [{:a => 1}] }
      let(:output){ "" }
      let(:expected){ "+----+\n"\
                      "| :a |\n"\
                      "+----+\n"\
                      "|  1 |\n"\
                      "+----+\n"
      }
      it{ should == expected }
    end

  end
end
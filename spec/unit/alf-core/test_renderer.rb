require 'spec_helper'
module Alf
  describe Renderer do
    
    subject{ Renderer }
    it { should respond_to(:rash) }
    it { should respond_to(:text) }

    describe 'renderer' do
      subject{ Renderer.renderer(:rash) } 
      it{ should be_a(Renderer) }
    end
      
    describe 'rash' do
      subject{ Renderer.rash(input) } 
      let(:input){ [{:a => 1}] }
      let(:output){ "" }
      let(:expected){ "{:a => 1}\n" }
      specify{ 
        subject.should be_a(Renderer)
        subject.execute(output).should == expected
      }
    end

    describe 'rash --pretty' do
      subject{ Renderer.rash(input, {:pretty => true}) } 
      let(:input){ [{:a => 1}] }
      let(:output){ "" }
      let(:expected){ "{\n  :a => 1\n}\n" }
      specify{ 
        subject.should be_a(Renderer)
        subject.execute(output).should == expected
      }
    end
    
    describe 'text' do
      subject{ Renderer.text(input) } 
      let(:input){ [{:a => 1}] }
      let(:output){ "" }
      let(:expected){ "+----+\n"\
                      "| :a |\n"\
                      "+----+\n"\
                      "|  1 |\n"\
                      "+----+\n"
      }
      specify{ 
        subject.should be_a(Renderer)
        subject.execute(output).should == expected
      }
    end

  end
end

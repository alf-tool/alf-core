require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Renderer do
    
    subject{ Renderer }
    it { should respond_to(:rash) }
    it { should respond_to(:text) }
    
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
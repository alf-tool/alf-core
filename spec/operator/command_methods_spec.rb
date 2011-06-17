require File.expand_path('../../spec_helper', __FILE__)
module Alf
  describe Operator::CommandMethods do
    
    let(:cmd){ Object.new.extend(Operator::CommandMethods) }
    
    describe "split_command_args" do
    
      subject{ cmd.send(:split_command_args, args) }

      describe "when applied to both operands and args" do
        let(:args)    { %w{op1 op2 -- a b c} }
        let(:expected){ [ %w{op1 op2}, %w{a b c} ] }
        it { should == expected }
      end
      
      describe "when applied to one operand only" do
        let(:args)    { %w{op1} }
        let(:expected){ [ %w{op1}, %w{} ] }
        it { should == expected }
      end
      
      describe "when applied to two operands only" do
        let(:args)    { %w{op1 op2} }
        let(:expected){ [ %w{op1 op2}, %w{} ] }
        it { should == expected }
      end
      
      describe "when applied to args only" do
        let(:args)    { %w{-- a b c} }
        let(:expected){ [ [$stdin], %w{a b c} ] }
        it { should == expected }
      end
      
    end
      
  end
end
require 'spec_helper'
module Alf
  module Shell
    describe Main, "class methods for doc" do

      specify "relational_operators" do
        Shell::Main.relational_operators.should_not be_empty
        Shell::Main.relational_operators.each do |cmd|
          cmd.should_not be_command
          cmd.should be_operator
          cmd.should respond_to(:run)
        end
      end

      specify "experimental_operators" do
        Shell::Main.experimental_operators.should_not be_empty
        Shell::Main.experimental_operators.each do |cmd|
          cmd.should_not be_command
          cmd.should be_operator
          cmd.should respond_to(:run)
        end
      end

      specify "non_relational_operators" do
        Shell::Main.non_relational_operators.should_not be_empty
        Shell::Main.non_relational_operators.each do |cmd|
          cmd.should_not be_command
          cmd.should be_operator
          cmd.should respond_to(:run)
        end
      end

      specify "other_non_relational_commands" do
        Shell::Main.other_non_relational_commands.should_not be_empty
        Shell::Main.other_non_relational_commands.each do |cmd|
          cmd.should be_command
          cmd.should_not be_operator
          cmd.should respond_to(:run)
        end
      end
        
    end # class methods for doc
  end # module Shell
end # module Alf

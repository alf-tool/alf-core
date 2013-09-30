require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "completude over algebra" do

      Algebra::Operator.registered.each do |operator|
        it "support #{operator}" do
          compiler.should respond_to(:"on_#{operator.rubycase_name}")
        end
      end

    end
  end
end

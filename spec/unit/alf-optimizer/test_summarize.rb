require 'optimizer_helper'
module Alf
  describe "summarize" do

    let(:summarization){
      Summarization.coerce(:total => "sum{ qty }")
    }
    subject{ summarize(an_operand, [:id], summarization) }

    let(:split_attributes){ subject.summarization.to_attr_list }

    it_should_behave_like "a split-able expression for restrict"

  end
end
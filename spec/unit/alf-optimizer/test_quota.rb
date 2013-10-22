require 'optimizer_helper'
module Alf
  describe "quota" do

    let(:summarization){
      Summarization.coerce(:total => Aggregator.sum{ qty })
    }

    subject{ quota(an_operand, [:id], [[:x, :asc]], summarization) }

    let(:split_attributes){ subject.summarization.to_attr_list }

    it_should_behave_like "a split-able expression for restrict"

  end
end
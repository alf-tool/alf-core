require 'spec_helper'
module Alf
  class Renderer
    describe Rash do

      context 'the class' do
        subject{ Rash }

        it_should_behave_like "a Renderer class"
      end

      context 'an instance' do
        subject{ Rash.new(input).execute("") }

        context "when a Relation" do
          let(:input){ Relation(id: [1, 2]) }
          let(:expected){ "{:id => 1}\n{:id => 2}\n" }

          it 'outputs as expected' do
            subject.should eq(expected)
          end
        end

        context "when a Hash" do
          let(:input){ {id: 1} }
          let(:expected){ "{:id => 1}\n" }

          it 'outputs as expected' do
            subject.should eq(expected)
          end
        end
      end

    end
  end
end

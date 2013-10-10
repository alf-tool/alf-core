require 'spec_helper'
module Alf
  module Algebra
    describe Operator, "to_ascii_tree" do

      subject{ operator.to_ascii_tree }

      context 'on an unary operator' do
        let(:operator){
          project(suppliers, [:sid, :name])
        }

        it 'returns the expected tree' do
          subject.should eq("project [:sid, :name]\n+-- suppliers\n")
        end
      end

      context 'on an unary operator with options' do
        let(:operator){
          project(suppliers, [:sid, :name], allbut: true)
        }

        it 'returns the expected tree' do
          subject.should eq("project [:sid, :name], {:allbut => true}\n+-- suppliers\n")
        end
      end

      context 'on an binary operator' do
        let(:operator){
          union(suppliers, parts)
        }

        it 'returns the expected tree' do
          subject.should eq("union\n+-- suppliers\n+-- parts\n")
        end
      end

    end
  end
end

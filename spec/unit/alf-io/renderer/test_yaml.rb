require 'spec_helper'
module Alf
  class Renderer
    describe YAML do

      describe 'the class itself' do
        subject{ YAML }

        it_should_behave_like "a Renderer class"
      end

      subject{ YAML.new(input).execute('') }

      describe "execute" do
        let(:input){ Relation(id: [1, 2]) }

        it 'outputs as expected' do
          ::YAML.load(subject).should eq([{"id" => 1}, {"id" => 2}])
        end
      end

      describe "when relation-valued attributes" do
        let(:input){ Relation(sid: "S1", parts: Relation(pid: ["P1", "P2"])) }

        it 'converts to arrays and hashes' do
          subject.should_not =~ /Relation/
          subject.should_not =~ /Tuple/
        end
      end

      describe 'when a class overrides encode_with' do
        let(:adt){ Class.new{
          def encode_with(coder)
            coder.represent_map(nil, "foo" => "bar")
          end
          def self.name
            "AUserDefinedClass"
          end
        }}

        let(:input){ Relation(value: adt.new) }

        it 'delegates to to_yaml' do
          subject.should_not =~ /ruby\/object/
          subject.should_not =~ /AUserDefinedClass/
        end
      end

    end
  end
end

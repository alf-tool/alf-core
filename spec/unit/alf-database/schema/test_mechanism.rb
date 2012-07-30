require 'spec_helper'
module Alf
  class Database
    describe Schema do

      subject{ Schema.new{ relvar :suppliers } }

      it{ should be_a(Module) }

      it "has a :suppliers instance method" do
        lambda{
          subject.instance_method(:suppliers)
        }.should_not raise_error(NameError)
      end

      context 'when included' do
        let(:receiver){ Object.new.extend(subject) }

        before do
          def receiver.context
            :foo
          end
        end

        it 'it serves a :suppliers VarRef' do
          receiver.suppliers.should be_a(Alf::Operator::VarRef)
        end

        it 'binds context correctly' do
          receiver.suppliers.context.should eq(:foo)
        end
      end

    end
  end
end
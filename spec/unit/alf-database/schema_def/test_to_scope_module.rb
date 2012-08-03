require 'spec_helper'
module Alf
  class Database
    describe SchemaDef, 'to_scope_module' do

      module HelpingMethods
        def helping_method
          :helping_method
        end
      end

      let(:defn){ 
        SchemaDef.new do 
          relvar :suppliers
          schema(:sub){
            relvar :parts
          }
          helpers HelpingMethods
          helpers do
            def bar; :bar; end
          end
        end 
      }

      subject{ defn.to_scope_module }

      it{ should be_a(Module) }

      context 'when included' do
        let(:receiver){ Object.new.extend(subject) }

        before do
          def receiver.context
            :foo
          end
        end

        it 'it serves a :suppliers VarRef with correct binding' do
          receiver.suppliers.should be_a(Alf::Operator::VarRef)
          receiver.suppliers.context.should eq(:foo)
        end

        it 'serves sub.parts as a VarRef with correct binding' do
          receiver.sub.parts.should be_a(Alf::Operator::VarRef)
          receiver.sub.parts.context.should eq(:foo)
        end

        it 'serves module helpers as defined' do
          receiver.helping_method.should eq(:helping_method)
        end

        it 'serves anonymous helpers as defined' do
          receiver.bar.should eq(:bar)
        end
      end

    end
  end
end
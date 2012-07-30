require 'spec_helper'
module Alf
  class Database
    describe Schema, 'import native relvars' do

      let(:schema){
        Schema.new{
          relvar :suppliers
          import_native_relvars
        }
      }

      let(:fake_scope){
        Object.new.extend Module.new{
          def context
            self
          end
          def native_schema
            Module.new{ def foo; :foo; end }
          end
        }
      }

      before{ fake_scope.extend(schema) }

      it 'installs the native relvars' do
        fake_scope.should respond_to(:foo)
      end

      it 'installs the non-native relvars' do
        fake_scope.should respond_to(:suppliers)
      end

    end
  end
end
require 'spec_helper'
module Alf
  class Database
    describe SchemaDef, 'import_native_relvars' do

      let(:defn){
        SchemaDef.new{
          relvar :suppliers
          import_native_relvars
        }
      }

      let(:fake_scope){
        Object.new.extend Module.new{
          def context
            self
          end
          def native_schema_def
            SchemaDef.new{ relvar :foo }
          end
        }
      }

      before{ fake_scope.extend(defn.to_scope_module) }

      it 'installs the native relvars' do
        fake_scope.should respond_to(:foo)
      end

      it 'installs the non-native relvars' do
        fake_scope.should respond_to(:suppliers)
      end

    end
  end
end
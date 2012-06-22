require 'spec_helper'
describe Alf::Database, 'helpers' do

  let(:db){ 
    examples_database do
      helpers do
        def upcase(arg)
          arg.upcase
        end
      end
    end
  }

  it 'is available in extension queries' do
    pending{
      suppliers = Relation([{:name => "John"}])
      expected  = suppliers.extend(:up => lambda{ name.upcase })
      observed  = db.evaluate{
        (extend suppliers, :up => lambda{ upcase(name) })
      }
      observed.should eq(expected)
    }
  end

end

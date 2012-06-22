require 'spec_helper'
describe Alf::Database, 'helpers' do

  let(:db){ 
    examples_database do
      helpers HelpersInScope
      helpers do
        def suppliers
          Relation(:name => "John")
        end
        def quantities
          Relation(:qty => [ 12, 20, 37 ])
        end
        def tax
          13
        end
      end
    end
  }

  it 'are available in extensions' do
    expected = Relation(:name => "John", :hello => "Hello John!")
    observed = db.evaluate{
      extend(suppliers, :hello => lambda{ hello(name) })
    }
    observed.should eq(expected)
  end

  it 'are available in restrictions' do
    expected = Relation(:name => "John")
    observed = db.evaluate{
      restrict(suppliers, lambda{ hello(name) == "Hello John!" })
    }
    observed.should eq(expected)
  end

  it 'are available in defaults' do
    expected = Relation(:name => "John", :hello => "Hello John!")
    observed = db.evaluate{
      defaults(suppliers, :hello => lambda{ hello(name) })
    }
    observed.should eq(expected)
  end

  it 'are available in summarizations' do
    expected = Relation(:total => (12+20+37)*13)
    observed = db.evaluate{
      summarize(quantities, [], :total => sum{ qty * tax })
    }
    observed.should eq(expected)
  end

end

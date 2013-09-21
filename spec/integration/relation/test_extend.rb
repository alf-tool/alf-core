require 'spec_helper'
describe Alf::Relation, 'extend' do

  let(:rel) {
    Relation(name: ["Jones", "Smith"])
  }

  let(:expected){
    Relation(name: ["JONESfoo", "SMITHfoo"])
  }

  let(:scoped){
    "foo"
  }

  it 'supports procs of arity 1' do
    rel.extend(foo: ->(t){ t.name.upcase + scoped })
  end

end
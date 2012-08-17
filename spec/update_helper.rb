require 'spec_helper'

class UpdateContext

  def initialize
    @requests = []
  end
  attr_reader :requests

  def iterator(name)
    Alf::Support::FakeOperand.new(self).with_name(name)
  end

  def heading(name)
    case name
    when :suppliers then Alf::Heading[:sid => Integer, :name  => String]
    when :parts     then Alf::Heading[:pid => Integer, :color => String]
    end
  end

  def insert(name, tuples)
    tuples = Alf::Engine::Compiler.new.call(tuples).to_a
    requests << [:insert, name, tuples]
  end

  def delete(name, predicate)
    requests << [:delete, name, predicate]
  end

  def update(name, updating, predicate)
    requests << [:update, name, updating, predicate]
  end

end

module Helpers

  def an_update_context
    UpdateContext.new
  end

  def db_context
    @context ||= an_update_context
  end

  def suppliers
    db_context.iterator(:suppliers)
  end

  def parts
    db_context.iterator(:parts)
  end

  def some_tuples
    [ { :id => 1 }, { :id => 2 } ]
  end

  def insert(expr, tuples)
    Alf::Update::Inserter.new.call(expr, tuples)
  end

  def delete(expr, predicate)
    Alf::Update::Deleter.new.call(expr, predicate)
  end

  def update(expr, updating, predicate)
    Alf::Update::Updater.new.call(expr, updating, predicate)
  end

end

RSpec.configure do |c|
  c.include Alf::Lang::Functional
end
require 'spec_helper'

class UpdateContext

  def initialize
    @requests = []
  end
  attr_reader :requests

  def heading(name)
    case name
    when :suppliers then Alf::Heading[:sid => Integer, :name  => String]
    when :parts     then Alf::Heading[:pid => Integer, :color => String]
    end
  end

  def insert(name, tuples)
    requests << [:insert, name, tuples.to_a]
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
    Alf::Algebra.named_operand(:suppliers, db_context)
  end

  def parts
    Alf::Algebra.named_operand(:parts, db_context)
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
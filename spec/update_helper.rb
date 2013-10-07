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
    @suppliers ||= an_operand
      .with_connection(db_context)
      .with_name(:suppliers)
      .with_heading(sid: String, name: String, status: Integer, city: String)
      .with_keys([:sid], [:name])
  end

  def supplies
    @supplies ||= an_operand
      .with_connection(db_context)
      .with_name(:supplies)
      .with_heading(sid: String, pid: String, qty: Integer)
      .with_keys([:sid, :pid])
  end

  def parts
    @parts ||= an_operand
      .with_connection(db_context)
      .with_name(:parts)
      .with_heading(pid: String, name: String, color: String, weight: Float, city: String)
      .with_keys([:pid])
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

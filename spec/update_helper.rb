require 'spec_helper'

class UpdateContext

  def initialize
    @requests = []
  end
  attr_reader :requests

  def connection
    self
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

end

module Helpers

  def an_update_context
    UpdateContext.new
  end

  def context
    @context ||= an_update_context
  end

  def suppliers
    var_ref(:suppliers, context)
  end

  def parts
    var_ref(:parts, context)
  end

  def some_tuples
    [ { :id => 1 }, { :id => 2 } ]
  end

  def var_ref(name, context)
    Alf::Operator::VarRef.new(context, name)
  end

  def insert(expr, tuples)
    Alf::Update::Inserter.new.call(expr, tuples)
  end

end

RSpec.configure do |c|
  c.include Alf::Lang::Functional
end
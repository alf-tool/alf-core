$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alf-core'
require "rspec"
require 'shared/an_operator_class'
require 'shared/a_valid_type_implementation'
require 'shared/a_value'
require 'shared/a_scope'
require 'shared/a_cog'

(Path.dir/"unit").glob("**/shared_examples/*").each do |f|
  require(f)
end

module Helpers

  SUPPLIER_NAMES = ["Smith", "Clark", "Jones", "Blake", "Adams"]

  def examples_path
    @examples_path ||= Path.backfind('examples/operators')
  end

  def a_lispy
    Alf::Lang::Lispy.new
  end

  def parse(*args, &bl)
    a_lispy.parse(*args, &bl)
  end

  def supplier_names
    SUPPLIER_NAMES
  end

  def supplier_names_relation
    Relation(:name => supplier_names)
  end

  def examples_database(&bl)
    Alf.examples
  end

  def sap_adapter
    Alf::Adapter.factor(examples_path)
  end

  def sap_db
    Alf::Database.new(sap_adapter)
  end

  def sap_conn
    sap_db.connection
  end

  def suppliers
    Alf::Algebra.named_operand(:suppliers, examples_database)
  end

  def an_operand(cog = nil)
    Alf::Algebra::Operand::Fake.new(nil, cog)
  end

  def viewpoint(&bl)
    Module.new{
      include Alf::Viewpoint
      instance_exec(&bl)
    }
  end

end

module HelpersInScope
  def hello(who); "Hello #{who}!"; end
  def world; "world"; end
end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
  c.filter_run_excluding :ruby19 => (RUBY_VERSION < "1.9")
end

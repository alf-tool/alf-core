$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alf'
require "rspec"
require 'path'

def _(path, file)
  File.expand_path("../#{path}", file)
end

def wlang(str, binding)
  str.gsub(/\$\(([\S]+)\)/){ Kernel.eval($1, binding) }
end

require 'shared/an_operator_class'
require 'shared/a_valid_type_implementation'
require 'shared/a_value'
require 'shared/a_scope'

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

  def supplier_names
    SUPPLIER_NAMES
  end

  def supplier_names_relation
    Relation(:name => supplier_names)
  end

  def examples_database(&bl)
    if bl
      raise NotImplementedError, "Block no longer supported"
    else
      Alf.examples
    end
  end

  def suppliers
    Alf::Algebra.named_operand(:suppliers, examples_database)
  end

  def an_operand
    Alf::Algebra::Operand::Fake.new
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

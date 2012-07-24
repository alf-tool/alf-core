$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alf'
require "rspec"
require 'epath'

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
      Class.new(Alf::Database, &bl).connect(examples_path)
    else
      Alf::Database.examples
    end
  end

  def parse(*args, &bl)
    lispy = Alf::Tools::Scope.new([Alf::Lang::Functional], self)
    lispy.evaluate(*args, &bl)
  end

  def operand_with_heading(h)
    Struct.new(:heading).new(Alf::Heading[h])
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

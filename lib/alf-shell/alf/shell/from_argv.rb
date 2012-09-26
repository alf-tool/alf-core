module Alf
  module Shell

    FROM_ARGV = Myrrha.coercions do |c|

      # ARGV -> Boolean
      c.coercion(Array, Boolean){|argv,_|
        throw :next_rule if argv.size > 1
        Alf::Support.coerce(argv.first || false, Boolean)
      }

      # ARGV -> Size
      c.coercion(Array, Size){|argv,_|
        throw :next_rule if argv.size > 1
        Size.new(Integer(argv.first || 0))
      }

      # ARGV -> AttrName
      c.coercion(Array, AttrName){|argv,_|
        throw :next_rule if argv.size > 1
        AttrName.coerce(argv.first)
      }

      # ARGV -> AttrList
      c.coercion(Array, AttrList){|argv,_|
        AttrList.coerce(argv)
      }

      # ARGV -> Heading
      c.coercion(Array, Heading){|argv,_|
        Heading.coerce(argv)
      }

      # ARGV -> Ordering
      c.coercion(Array, Ordering){|argv,_|
        Ordering.coerce(argv)
      }

      # ARGV -> Renaming
      c.coercion(Array, Renaming){|argv,_|
        Renaming.coerce(argv)
      }

      # ARGV -> Summarization
      c.coercion(Array, Summarization){|argv,_|
        Summarization.coerce(argv)
      }

      # ARGV -> TupleComputation
      c.coercion(Array, TupleComputation){|argv,_|
        TupleComputation.coerce(argv)
      }

      # ARGV -> TupleExpression
      c.coercion(Array, TupleExpression){|argv,_|
        throw :next_rule if argv.size != 1
        TupleExpression.coerce(argv.first)
      }

      # ARGV -> Predicate
      c.coercion(Array, Predicate){|argv,_|
        if argv.size == 1
          Predicate.coerce(argv.first)
        elsif (argv.size % 2) == 0
          Predicate.coerce(Hash[argv.each_slice(2).map{|k,v| [k.to_sym, eval(v)] }])
        else
          throw :next_rule
        end
      }

    end

    def self.from_argv(argv, target_domain)
      FROM_ARGV.coerce(argv, target_domain)
    end

  end # module Shell
end # module Alf
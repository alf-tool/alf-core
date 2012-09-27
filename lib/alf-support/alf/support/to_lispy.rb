module Alf
  module Support

    # Converts `value` to a lispy expression.
    #
    # Example:
    #
    #     expr = Alf.examples.compile{
    #       (project :suppliers, [:name])
    #     }
    #     Support.to_lispy(expr)
    #     # => (project :suppliers, [:name])
    #
    # @param [Object] expr any ruby object denoting a lispy expression
    # @return [String] a lispy expression for `value`
    def to_lispy(expr)
      ToLispy.apply(expr)
    end

    # Myrrha rules for converting to ruby literals
    ToLispy = Myrrha::coercions do |r|

      # Delegate to #to_lispy if it exists
      lispy_able = lambda{|v,rd| v.respond_to?(:to_lispy)}
      r.upon(lispy_able) do |v,rd|
        v.to_lispy
      end

      # AttrList -> [:sid, :sname, ...]
      r.upon(Types::AttrList) do |v, rd|
        Support.to_ruby_literal(v.attributes)
      end

      # Heading -> {:sid => String, ...}
      r.upon(Types::Heading) do |v, rd|
        Support.to_ruby_literal(v.to_h)
      end

      # Ordering -> [[:sid, :asc], ...]
      r.upon(Types::Ordering) do |v, rd|
        Support.to_ruby_literal(v.ordering)
      end

      # Renaming -> {:old => :new, ...}
      r.upon(Types::Renaming) do |v, rd|
        Support.to_ruby_literal(v.renaming)
      end

      # Predicate -> ->{ ... }
      r.upon(Predicate) do |v, rd|
        "->{ #{v.to_ruby_code} }"
      end

      # TupleExpression -> ->{ ... }
      r.upon(Types::TupleExpression) do |v, rd|
        "->{ #{v.has_source_code!} }"
      end

      # TupleComputation -> { :big => ->{ ... }, ... }
      r.upon(Types::TupleComputation) do |v, rd|
        "{" + v.computation.map{|name,compu|
          [name.inspect, r.coerce(compu)].join(" => ")
        }.join(', ') + "}"
      end

      # Summarization -> { :total => ->{ ... } }
      r.upon(Types::Summarization) do |v, rd|
        "{" + v.map{|name,compu|
          [name.inspect, r.coerce(compu)].join(" => ")
        }.join(', ') + "}"
      end

      # Relvar -> its expression
      r.upon(lambda{|v,rd| Relvar === v}) do |v, rd|
        Support.to_lispy(v.expr)
      end

      # Aggregator -> agg.source
      r.upon(lambda{|v,_| Aggregator === v}) do |v, rd|
        v.has_source_code!
      end

      # Algebra::Operator -> (operator operands, args, options)
      cmd = lambda{|v,_| (Algebra::Operator === v)}
      r.upon(cmd) do |v,rd|
        cmdname  = v.class.rubycase_name
        oper, args, opts = v.class.signature.collect_on(v)
        args = opts.empty? ? (oper + args) : (oper + args + [ opts ])
        args = args.map{|arg| r.coerce(arg) }
        "#{cmdname}(#{args.join(', ')})"
      end

      # Let's assume to to_ruby_literal will make the job
      r.fallback(Object) do |v, _|
        Support.to_ruby_literal(v) rescue v.inspect
      end

    end # ToLispy

  end # module Support
end # module Alf

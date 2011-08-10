module Alf
  module Tools

    # Myrrha rules for converting to ruby literals
    ToLispy = Myrrha::coercions do |r|
      
      # Delegate to #to_lispy if it exists
      lispy_able = lambda{|v,rd| v.respond_to?(:to_lispy)}
      r.upon(lispy_able) do |v,rd|
        v.to_lispy
      end

      # On AttrList
      r.upon(Types::AttrList) do |v, rd|
        Tools.to_ruby_literal(v.attributes)
      end

      # On Heading
      r.upon(Types::Heading) do |v, rd|
        Tools.to_ruby_literal(v.attributes)
      end

      # On Ordering
      r.upon(Types::Ordering) do |v, rd|
        Tools.to_ruby_literal(v.ordering)
      end

      # On Renaming
      r.upon(Types::Renaming) do |v, rd|
        Tools.to_ruby_literal(v.renaming)
      end

      # On Renaming
      r.upon(lambda{|v,rd| Iterator::Proxy === v}) do |v, rd|
        Tools.to_ruby_literal(v.dataset)
      end

      cmd = lambda{|v,_| (Command === v) || (Operator === v)}
      r.upon(cmd) do |v,rd|
        cmd  = v.class.command_name.to_s.gsub('-', '_')
        oper, args, opts = v.class.signature.collect_on(v)
        args = opts.empty? ? (oper + args) : (oper + args + [ opts ])
        args = args.collect{|arg| r.coerce(arg)}
        "(#{cmd} #{args.join(', ')})"
      end

      # Let's assume to to_ruby_literal will make the job
      r.fallback(Object) do |v, _|
        Tools.to_ruby_literal(v)
      end

    end
    
    # Delegated to ToLispy
    def to_lispy(value)
      ToLispy.apply(value)
    end
    
  end # module Tools
end # module Alf

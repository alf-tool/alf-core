module Alf
  module Tools
    # Provides an operator signature
    class Signature
      
      def initialize(args)
        @args = args
      end
      
      def install(clazz)
        @args.each do |siginfo|
          name, dom, = siginfo
          clazz.instance_eval <<-EOF
            attr_accessor :#{name}
            private :#{name}=
          EOF
        end
      end
      
      def from_xxx(args, coercer)
        @args.zip(args).collect do |sigpart,subargs|
          name, dom, default = sigpart
          
          # coercion
          val = if Array(subargs).empty?
            Tools.coerce(default, dom)
          else
            dom.send(coercer, subargs)
          end
          
          # check and yield
          if val.nil?
            raise ArgumentError, "Invalid `#{subargs.inspect}` for #{sigpart.inspect}"
          else
            block_given? ? yield(name, val) : val
          end
        end
      end
      
      def from_args(args, &block)
        from_xxx(args, :coerce, &block)
      end
      
      def parse_args(args, receiver)
        from_args(args) do |name,val|
          receiver.send(:"#{name}=", val)
        end
      end
      
      def from_argv(argv, &block)
        from_xxx(argv, :from_argv, &block)
      end
      
      def parse_argv(argv, receiver)
        from_argv(argv) do |name,val|
          receiver.send(:"#{name}=", val)
        end
      end
      
      EMPTY = Signature.new []
    end # class Signature
  end # module Tools
end # module Alf
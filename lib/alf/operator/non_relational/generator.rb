module Alf
  module Operator::NonRelational
    class Generator < Alf::Operator()
      include Operator::NonRelational, Operator::Nullary

      class SizeDom < Integer
        extend Myrrha::Domain

        def self.coerce(args)
          Tools.coerce(args, Integer)
        end

        def self.from_argv(argv, opts = {})
          coerce(argv.first)
        end

        def self.predicate
          @predicate ||= lambda{|i| i >= 0}
        end

      end # SizeDom

      signature do |s|
        s.argument :size, SizeDom, 10
        s.argument :attr_name, AttrName, :num
      end
          
      protected

      def _each
        size.times do |i|
          yield(attr_name => i+1)
        end
      end

    end # class Generator
  end # module Operator::NonRelational
end # module Alf

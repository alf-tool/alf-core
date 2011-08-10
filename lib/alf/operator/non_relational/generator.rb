module Alf
  module Operator::NonRelational
    class Generator < Alf::Operator()
      include Operator::NonRelational, Operator::Nullary

      class Size < Integer
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

      end # Size

      signature do |s|
        s.argument :size, Size, 10
        s.argument :as,   AttrName, :num
      end
          
      protected

      def _each
        size.times do |i|
          yield(@as => i+1)
        end
      end

    end # class Generator
  end # module Operator::NonRelational
end # module Alf

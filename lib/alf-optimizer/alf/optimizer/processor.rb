module Alf
  class Optimizer
    class Processor
      include Lang::Functional

      def initialize(context = nil)
        @context = context
      end
      attr_reader :context

      def apply(expr, *args, &bl)
        name = Tools.ruby_case(Tools.class_name(expr.class))
        meth = :"on_#{name}"
        meth = :on_missing unless respond_to?(meth)
        send(meth, expr, *args, &bl)
      end

    end # class Processor
  end # class Optimizer
end # module Alf
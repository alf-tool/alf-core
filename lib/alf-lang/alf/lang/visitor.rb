module Alf
  module Lang
    module Visitor

    private

      def to_method_name(expr, prefix = "on_")
        if expr.class.name.to_s =~ /^Alf::Operator/
          name = Tools.ruby_case(Tools.class_name(expr.class))
          meth = :"#{prefix}#{name}"
          meth = :"#{prefix}missing" unless respond_to?(meth)
          meth
        else
          :on_missing
        end
      end

    end # module Visitor
  end # module Lang
end # module Alf
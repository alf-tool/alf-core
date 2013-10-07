module Alf
  module Algebra
    class Restrict
      include Operator
      include Relational
      include Unary

      signature do |s|
        s.argument :predicate, Predicate, Predicate.tautology
      end

      def heading
        @heading ||= operand.heading
      end

      def keys
        @keys ||= begin
          keys = operand.keys
          unless (cv = predicate.constant_variables).empty?
            keys = keys.map{|k| k - cv }
          end
          keys
        end
      end

    private

      def _type_check(options)
        no_unknown!(predicate.free_variables - operand.attr_list)
      end

    end # class Restrict
  end # module Algebra
end # module Alf

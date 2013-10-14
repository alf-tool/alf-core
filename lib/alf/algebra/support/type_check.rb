module Alf
  module Algebra
    module TypeCheck

      def type_check_error!(msg)
        raise TypeCheckError, msg
      end

      def no_unknown!(unknown)
        unknown = unknown.to_a
        unless unknown.empty?
          msg = "#{to_s}: no such attribute"
          msg << ((unknown.size > 1) ? "s " : " ")
          msg << unknown.map{|a| "`#{a}`" }.join(',')
          type_check_error!(msg)
        end
      end
      private :no_unknown!

      def no_name_clash!(left, right)
        commons = (left & right).to_a
        unless commons.empty?
          msg = "#{to_s}: cannot override "
          msg << commons.map{|a| "`#{a}`" }.join(',')
          type_check_error!(msg)
        end
      end

      def valid_ordering!(ordering, attr_list)
        no_unknown!(ordering.to_attr_list - attr_list)
      end

      def same_heading!(left, right)
        unless left == right
          type_check_error!("heading mismatch `#{left}` vs. `#{right}`")
        end
      end

      def joinable_headings!(left, right, options)
        if options[:strict]
          commons = left.to_attr_list & right.to_attr_list
          left_h, right_h = left.project(commons), right.project(commons)
          same_heading!(left_h, right_h)
        else
          left & right
        end
      end

    end # module TypeCheck
  end # module Algebra
end # module Alf

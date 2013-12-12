module Alf
  module Types
    class TypeCheck

      Error = Class.new(Alf::Error)

      def initialize(heading, strict = true)
        @heading   = heading
        @attr_list = heading.to_attr_list
        @strict    = strict
      end
      attr_reader :heading

      def strict?
        @strict
      end

      def ===(tuple)
        return nil unless TupleLike===tuple
        case @attr_list <=> (AttrList.new(tuple.keys) rescue nil)
        when 1      # some attributes are missing
          return false if @strict
        when -1     # extra attributes are present
          return false
        when nil    # both missing and extra attributes
          return nil
        end
        tuple.to_hash.all?{|(k,v)| v.nil? or (@heading[k] === v) }
      end

      def check!(tuple)
        check_type!(tuple)
        check_missing_attributes!(tuple)
        check_extra_attributes!(tuple)
        check_values!(tuple)
      end

      def error(msg, what = nil)
        unless what.nil?
          msg << (what.size == 1 ? " `" : "s `") << what.join(', ') << "`"
        end
        raise Error, msg
      end

    private

      def check_type!(tuple)
        error("not a tuple") unless TupleLike===tuple
      end

      def check_missing_attributes!(tuple)
        expec_keys, tuple_keys = @attr_list, AttrList.new(tuple.keys)
        unless (missing = expec_keys - tuple_keys).empty?
          error("Missing attribute", missing.to_a)
        end
      end

      def check_extra_attributes!(tuple)
        expec_keys, tuple_keys = @attr_list, AttrList.new(tuple.keys)
        unless (extra = tuple_keys - expec_keys).empty?
          error("Unexpected attribute", extra.to_a)
        end
      end

      def check_values!(tuple)
        tuple.to_hash.each_pair do |k,v|
          expected = @heading[k]
          unless v.nil? or v.is_a?(expected) or (expected === v)
            error("Invalid value `#{k}` for `#{expected}`")
          end
        end
      end

    end # class TypeCheck
  end # module Types
end # module Alf

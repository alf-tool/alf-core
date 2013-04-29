module Alf
  module Types
    class TypeCheck

      def initialize(heading, strict = true)
        @heading   = heading
        @attr_list = heading.to_attr_list
        @strict    = strict
      end

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

    end # class TypeCheck
  end # module Types
end # module Alf

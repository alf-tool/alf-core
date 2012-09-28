module Alf
  module Types
    class Keys
      extend Domain::Reuse.new(Array)
      include Support::OrderedSet

      coercions do |c|
        c.coercion(Array){|v,_| Keys.new(v.map{|e| AttrList.coerce(e)}) }
      end
      def self.[](*args); coerce(args); end

      def if_empty(keys = nil, &bl)
        return self unless empty?
        Keys.coerce(keys || bl.call)
      end

      def project(attributes, allbut = false)
        map{|k| k.project(attributes, allbut) }
      end

      def rename(renaming)
        renaming = Renaming.coerce(renaming)
        map{|k| renaming.rename_attr_list(k) }
      end

      def compact
        reject{|k| k.empty? }
      end

      EMPTY = Keys.new([])
    end # class Keys
  end # module Types
end # module Alf
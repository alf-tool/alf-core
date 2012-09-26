module Alf
  module Types
    class Keys
      include Myrrha::Domain::Impl.new([:keys])
      include Support::OrderedSet

      coercions do |c|
        c.coercion(Array){|arg,_| Keys.new arg.map{|k| AttrList.coerce(k)} }
      end

      class << self

        def [](*args)
          coerce(args)
        end

      end # class << self

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

    protected

      def elements
        keys
      end

    end # class Keys
  end # module Types
end # module Alf
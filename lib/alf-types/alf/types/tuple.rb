module Alf
  module Types
    class Tuple
      extend Domain::Reuse.new(Hash)

      reuse :map, :size, :empty?, :[], :to_hash, :to_a, :keys, :values_at

      coercions do |c|
        c.coercion(Hash){|v,_| Tuple.new Support.symbolize_keys(v) }
      end

      def remap(&bl)
        self.class.new reused_instance.each_with_object({}){|(k,v),h| h[k] = yield(k,v)}
      end

      def merge(other, &bl)
        self.class.new reused_instance.merge(other.to_hash, &bl)
      end

      def project(attr_list)
        attrs = self.keys & attr_list.to_a
        self.class.new attrs.each_with_object({}){|k,h| h[k] = self[k]}
      end

      def allbut(attr_list)
        project(AttrList.new(keys) - attr_list)
      end

      def only(renaming)
        renaming = Renaming.coerce(renaming)
        self.class.new renaming.to_hash.each_with_object({}){|(o,n),h| h[n] = self[o] }
      end

      def rename(renaming)
        renaming = Renaming.coerce(renaming)
        self.class.new renaming.rename_tuple(self)
      end

      def coerce(heading)
        heading = Heading.coerce(heading)
        remap{|k,v|
          domain = heading[k]
          domain ? Support.coerce(v, domain) : v
        }
      end

      def extend(computation)
        computation = TupleComputation.coerce(computation)
        scope       = Support::TupleScope.new(self)
        computed    = computation.evaluate(scope)
        merge(computed)
      end

    end # module Tuple
  end # module Types
end # module Alf

module Alf
  class Tuple
    extend Domain::Reuse.new(Hash)
    extend Domain::HeadingBased.new(self)

    reuse :map, :size, :empty?, :[], :to_a, :keys, :values_at, :has_key?

    coercions do |c|
      c.coercion(Hash){|hash,type|
        type    = Tuple[Heading.infer(hash)] if Tuple==type
        hash    = Support.symbolize_keys(hash)
        hash    = hash.merge(type.heading){|k,v,t| Support.coerce(v, t) }
        type.new(hash).check_internal_representation!
      }
    end

    def check_internal_representation!
      raise TypeError, "Hash expected"          unless reused_instance.is_a?(Hash)
      raise TypeError, "Not a tuple subclass"   unless self.class.superclass == Tuple
      raise TypeError, "Attributes mistmatch"   unless heading.to_attr_list  == AttrList.coerce(reused_instance.keys)
      raise TypeError, "Heading type mistmatch" unless heading === reused_instance
      self
    end

    def heading
      self.class.heading
    end

    def split(attr_list)
      return [ EMPTY, self ] if attr_list.empty?
      left, right = {}, to_hash
      (heading.to_attr_list & attr_list).each do |a|
        left[a] = right.delete(a)
      end
      self.class.split(attr_list).zip([left, right]).map{|t,v| t.new(v) }
    end

    def project(attr_list)
      split(attr_list).first
    end

    def allbut(attr_list)
      split(attr_list).last
    end

    def rename(renaming)
      renaming = Renaming.coerce(renaming)
      self.class.rename(renaming).new(renaming.rename_tuple(reused_instance))
    end

    def extend(computation)
      computation   = TupleComputation.coerce(computation)
      scope         = Support::TupleScope.new(self)
      computed      = computation.evaluate(scope)
      res_heading   = heading.merge(Heading.infer(computed))
      Tuple[res_heading].new(reused_instance.merge(computed))
    end

    def remap(&bl)
      res = reused_instance.each_with_object({}){|(k,v),n| n[k] = bl[k, v]}
      Tuple[Heading.infer(res)].new(res)
    end

    def merge(other)
      res = reused_instance.merge(other.to_hash)
      Tuple[Heading.infer(res)].new(res)
    end

    def to_hash(dup = true)
      dup ? reused_instance.dup : reused_instance
    end

    def to_json(*args, &bl)
      to_hash.to_json(*args, &bl)
    end

    def to_ruby_literal
      "Tuple(#{Support.to_ruby_literal(to_hash)})"
    end
    alias :inspect :to_ruby_literal

    EMPTY = Tuple[{}].new({})
    DUM   = EMPTY
  end # module Tuple
end # module Alf

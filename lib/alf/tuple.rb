module Alf
  class Tuple
    extend Domain::Reuse.new(Hash)
    extend Domain::HeadingBased.new(self)

    reuse :map, :size, :empty?, :[], :to_a, :keys, :values_at, :has_key?

    coercions do |c|
      c.coercion(Tuple){|tuple,type|
        c.coerce(tuple.to_hash, type)
      }
      c.coercion(Hash){|hash,type|
        type    = Tuple[Heading.infer(hash)] if Tuple==type
        hash    = type.heading.coerce(hash)
        type.new(hash).check_internal_representation!
      }
    end

    def self.heading_based_factored
      heading.each do |attrname,attrtype|
        define_method(attrname) do |*args, &bl|
          return super(*args, &bl) unless args.empty? && bl.nil?
          reused_instance[attrname]
        end
      end
      self
    end

    def check_internal_representation!
      error = lambda{|msg| raise TypeError, msg }
      error["Hash expected for representation"] unless reused_instance.is_a?(Hash)
      TypeCheck.new(self.class.heading, true).check!(reused_instance)
      self
    rescue TypeCheck::Error => ex
      error[ex.message]
    end

    def heading
      self.class.heading
    end

    def split(attr_list)
      return [ EMPTY, self ] if attr_list.empty?
      left, right = {}, to_hash(true)
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

    def to_attr_list
      heading.to_attr_list
    end

    def to_ruby_literal
      "Tuple(#{Support.to_ruby_literal(to_hash)})"
    end
    alias_method :inspect, :to_ruby_literal
    alias_method :to_s, :to_ruby_literal

    EMPTY = Tuple[{}].new({})
    DUM   = EMPTY
  end # module Tuple
end # module Alf

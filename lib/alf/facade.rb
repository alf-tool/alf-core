module Alf
  module Facade

    def database(*args, &bl)
      Alf::Database.new(*args, &bl)
    end

    def connect(*args, &bl)
      Alf::Database.connect(*args, &bl)
    end

    def query(*args, &bl)
      connect(*args) do |conn|
        conn.query(&bl)
      end
    end

    def examples_adapter
      Path.backfind('examples/suppliers_and_parts')
    end

    def examples(&bl)
      Alf::Database.connect examples_adapter, &bl
    end

    def reader(source, *args)
      Alf::Reader.reader(source, *args)
    end

    def Relation(first, *rest, &bl)
      if first.respond_to?(:to_relation) && rest.empty? && bl.nil?
        return first.to_relation
      else
        Alf::Relation.coerce(*rest.unshift(first), &bl)
      end
    end

    def Tuple(first, *rest, &bl)
      if first.respond_to?(:to_tuple) && rest.empty? && bl.nil?
        return first.to_tuple
      else
        tuple = Alf::Tuple.coerce(*rest.unshift(first))
        tuple = tuple.remap(&bl) if bl
        tuple
      end
    end

    def Heading(*args, &bl)
      Alf::Heading.coerce(*args, &bl)
    end

  end
end

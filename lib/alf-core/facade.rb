module Alf
  module Facade

    def database(*args, &bl)
      Alf::Database.new(*args, &bl)
    end

    def connect(*args, &bl)
      Alf::Database.connect(*args, &bl)
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

    def Relation(*args, &bl)
      Alf::Relation.coerce(*args, &bl)
    end

    def Tuple(*args, &bl)
      tuple = Alf::Tuple.coerce(*args)
      tuple = tuple.remap(&bl) if bl
      tuple
    end

    def Heading(*args, &bl)
      Alf::Heading.coerce(*args, &bl)
    end

  end
end

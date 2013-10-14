module Alf
  module Dsl

    Tuple    = Alf::Tuple
    Relation = Alf::Relation
    DUM      = Alf::Relation::DUM
    DEE      = Alf::Relation::DEE

    def Relation(*args, &bl)
      Alf::Relation(*args, &bl)
    end

    def Tuple(*args, &bl)
      Alf::Tuple(*args, &bl)
    end

    def Heading(*args, &bl)
      Alf::Heading(*args, &bl)
    end

  end # module Dsl
end # module Alf

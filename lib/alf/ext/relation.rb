Relation = Alf::Relation
DUM      = Alf::Relation::DUM
DEE      = Alf::Relation::DEE

def Relation(*args, &bl)
  Alf::Relation(*args, &bl)
end

def Tuple(*args, &bl)
  Alf::Tuple(*args, &bl)
end
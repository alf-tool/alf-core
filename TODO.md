* RENAME: add prefix, suffix and lambda renaming
  
    (rename :suppliers, [:name, :city], :prefix => "supplier_")
    (rename :suppliers, [:name, :city], :suffix => "_sup")
    (rename :suppliers, [:name, :city], lambda{|name| name.upcase}) 

* NEST: provide a multi-nesting ability?

    (nest (nest :supplies, [:a, :b], :x), [:x, :c], :y)
    => (nest :supplies, :x => [:a, :b], :y => [:x, :c])

    But this would only work with Ruby 1.9 as the hash order would be important
    as such

* GROUP: provide a multi-grouping ability?

    Similar to nest, with same limitation.
  
* Add PIVOT and UNPIVOT operators

* Add JOIN, MINUS, INTERSECT, MATCHING, NOT_MATCHING

* Add a to_ruby abstraction and replace inspect usages in TupleHandle and
  Rash renderer

* Find a way to complete the description of Quota...  
* Rework AlfFile that loads its operand in memory.

* RENAME: add prefix, suffix and lambda renaming

        (rename :suppliers, [:name, :city], :prefix => "supplier_")
        (rename :suppliers, [:name, :city], :suffix => "_sup")
        (rename :suppliers, [:name, :city], lambda{|name| name.upcase})

* WRAP: provide a multi-wrapping ability?

        (wrap (wrap :supplies, [:a, :b], :x), [:x, :c], :y)
         => (wrap :supplies, :x => [:a, :b], :y => [:x, :c])

    But this would only work with Ruby 1.9 as the hash order would be important
    as such

* GROUP: provide a multi-grouping ability?

    Similar to wrap, with same limitation.

* Add PIVOT and UNPIVOT operators

* Find a way to complete the description of Quota...

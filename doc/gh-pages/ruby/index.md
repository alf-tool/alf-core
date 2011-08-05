## Using Alf in Ruby

Alf comes with a Domain Specific Language (DSL), written in Ruby, for writing and executing relational queries. This DSL aims at being powerful yet simple and intuitive to use.

    #
    # What are total weight of supplied products, by city, then by product id?
    #
    
    (group \
      (summarize \
        (join :parts, :supplies), 
        [:city, :pid], 
        :total => Agg:sum{ weight * qty }),
      [:pid, :total], 
      :supplying)


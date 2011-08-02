## What is Alf, precisely?

* A set of shell commands to manipulate data with relational algebra. Those commands are able to manipulate .csv files, SQL tables, log files, and so on. Writing an adapter for recognizing other file formats is straightforward.

        #
        # What are total weight of supplied products, by city, then by product id?
        #

        $ alf join parts supplies | alf summarize -- city pid -- total 'sum{weight*qty}' | alf group -- pid total -- supplying | alf show

        +--------+---------------------+
        | :city  | :supplying          |
        +--------+---------------------+
        | London | +------+---------+  |
        |        | | :pid | :total  |  |
        |        | +------+---------+  |
        |        | | P1   | 7200.00 |  |
        |        | | P4   | 7000.00 |  |
        |        | | P6   | 1900.00 |  |
        |        | +------+---------+  |
        | Oslo   | +------+---------+  |
        |        | | :pid | :total  |  |
        |        | +------+---------+  |
        |        | | P3   | 6800.00 |  |
        |        | +------+---------+  |
        | Paris  | +------+----------+ |
        |        | | :pid | :total   | |
        |        | +------+----------+ |
        |        | | P2   | 17000.00 | |
        |        | | P5   |  6000.00 | |
        |        | +------+----------+ |
        +--------+---------------------+

* A Domain Specific Language (DSL), written in Ruby, for writing and executing relational queries. This DSL aims at being powerful yet simple and intuitive to use.

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


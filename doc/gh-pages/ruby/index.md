## Using Alf in Ruby

Alf implements a Domain Specific Language (DSL), for writing and executing relational queries. This DSL aims at being powerful yet simple and intuitive to use.

<pre class="theory"><code class="ruby">#                                                 
# What is the total weight of supplied products,     
# by city, then by product id?                    
#                                                 
(group                                            +--------+---------------------+
  (summarize (join :parts, :supplies),            | :city  | :supplying          |
    [:city, :pid],                                +--------+---------------------+
    :total => sum{ weight * qty }),               | London | +------+---------+  |
  [:pid, :total], :supplying)                     |        | | :pid | :total  |  |
                                                  |        | +------+---------+  |
                                                  |        | | P1   | 7200.00 |  |
                                                  |        | | P4   | 7000.00 |  |
                                                  |        | | P6   | 1900.00 |  |
                                                  | ...    | | ...  | ...     |  |
</code></pre>

### Evaluation of DSL expressions

* Ala "ruby -e", for shortest expressions (see also [Using Alf in Shell](shell/index))

<pre><code class="terminal">$ alf -e "(restrict :suppliers, ->{ city == 'London' })"</code></pre>

* Through .alf files that contain them

<pre><code class="terminal">$ alf path/to/my/query.alf</code></pre>

* In Ruby scripts and programs

<pre><code class="ruby">require 'alf'
db = Alf.examples
db.evaluate{
  (restrict :suppliers, ->{ city == 'London' })
}
</code></pre>

### A few bits and pieces you want to know

* Alf is not limited to the use of simple scalar types. Attribute can be any ruby class/object implementing a type/value in a consistent way. You also have full Ruby power in expressions:

<pre><code class="ruby">db.evaluate{
  (restrict :suppliers, ->{ city =~ /^P/ })
}</code></pre>

* Alf automatically resolves relation names according to an database of use. By default, the latter is bound to the examples bundled with Alf. This way, you can learn Alf without worrying about where data come from, or even get it as plain ruby objects:

<pre><code class="ruby">rel = db.evaluate{
  (join :suppliers, :cities)
}
puts rel.to_a
</code></pre>

* Of course, you can connect Alf to other datasources (see API doc)

<pre><code class="ruby">Alf.database("postgres://tom@localhost/myerp").evaluate{
  (summarize (join :bills, :clients), [:client_id], :total => sum{ qty*price })
}
</code></pre>

* Alf is shipped with a true `Relation` data structure, that is, a set of tuples. Those relations can be used as relation literals in DSL expressions.

<pre><code class="ruby">cities = Alf::Relation([
  {:city => "London"},
  {:city => "Paris"},
  {:city => "Oslo"}
])
</code></pre>

* While not idomatic and not recommended, you can also use Alf with an object-oriented style thanks to `Relation`:

<pre><code class="ruby">cities.extend(:bigname => ->{ city.upcase })</code></pre>

## Using Alf in shell

Alf comes with a set of operators and commands to evaluate relational queries (see the menu at left). 

* Operators always take relations (often one) as input and output a relation. 
* Input relations may come from .rash files (ruby hashes), .csv files, SQL tables, log files, and so on.
* Alf is read-only: it never modifies the files or SQL tables where the data come from!

Here is an example:

<pre><code class="bash"># What is the total weight of supplied products, 
# by city, then by product id?

$ alf join parts supplies | \
  alf summarize -- city pid -- total 'sum{weight*qty}' | \
  alf group -- pid total -- supplying | \
  alf show

+--------+---------------------+
| :city  | :supplying          |
+--------+---------------------+
| London | +------+---------+  |
|        | | :pid | :total  |  |
|        | +------+---------+  |
|        | | P1   | 7200.00 |  |
|        | | P4   | 7000.00 |  |
|        | | P6   | 1900.00 |  |
| ...    | | ...  | ...     |  |
</code></pre>

Refer to the menu at left to learn about available operators.

### A few bits and pieces you want to know

* Alf is not limited to the use of simple scalar types. Attribute can be any ruby class/object implementing a type/value in a consistent way. You also have full Ruby power in expressions:

<pre><code class="terminal">$ alf restrict suppliers -- "city =~ /^P/"</code></pre>

* Alf automatically resolves relation names according to an environment of use. By default, the latter is bound to the examples bundled with Alf. This way, you can learn Alf without worrying about where data come from, or even get it:

<pre><code class="terminal">$ alf show suppliers
$ alf --csv show suppliers > suppliers.csv</code></pre>

* But, you can also use .csv or .log files as first class input relations

<pre><code class="terminal">$ alf restrict suppliers.csv -- "city == 'Paris'"</code></pre>

* You can export any query result to a .csv, .yaml or ruby file with only one additional option

<pre><code class="terminal">$ alf --yaml restrict suppliers.csv -- "city == 'Paris'"</code></pre>

* Of course, you can connect Alf to other datasources

<pre><code class="terminal">$ alf --env=path/to/csv/files/ join bills clients
$ alf --env='postgres://tom@localhost/myerp' join bills clients
</code></pre>

* Alf supports `ALF_OPTS` global options. It also mimics Ruby `-Idirectory` and `-rlibrary` options.

<pre><code class="terminal">$ export ALF_OPTS=--env='postgres://tom@localhost/myerp' 
$ alf join bills clients
</code></pre>

* Most relational operators take relations as input and output a relation. Therefore, you can simply pipe alf invocations!

<pre><code class="terminal">$ alf join bills clients | alf restrict -- "country == 'France'"</code></pre>



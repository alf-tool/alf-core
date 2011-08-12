## Alf &mdash; Guided tour

Alf is shipped with example relations and is wired to them by default. These relations are based on the popular *suppliers-and-parts* example that C.J. Date uses in all his books (*S*, *P* and *SP* there are called `:suppliers`, `:parts` and `:supplies` here, respectively). Once Alf is installed, try this:

<pre class="theory"><code class="ruby">$ alf show database
+-------------------------------------+----------------------------------------------+------------------------+
| :suppliers                          | :parts                                       | :supplies              |
+-------------------------------------+----------------------------------------------+------------------------+
| +------+-------+---------+--------+ | +------+-------+--------+---------+--------+ | +------+------+------+ |
| | :sid | :name | :status | :city  | | | :pid | :name | :color | :weight | :city  | | | :sid | :pid | :qty | |
| +------+-------+---------+--------+ | +------+-------+--------+---------+--------+ | +------+------+------+ |
| | S1   | Smith |      20 | London | | | P1   | Nut   | Red    |  12.000 | London | | | S1   | P1   |  300 | |
| | S2   | Jones |      10 | Paris  | | | P2   | Bolt  | Green  |  17.000 | Paris  | | | S1   | P2   |  200 | |
| | S3   | Blake |      30 | Paris  | | | P3   | Screw | Blue   |  17.000 | Oslo   | | | S1   | P3   |  400 | |
| | S4   | Clark |      20 | London | | | P4   | Screw | Red    |  14.000 | London | | | S1   | P4   |  200 | |
| | S5   | Adams |      30 | Athens | | | P5   | Cam   | Blue   |  12.000 | Paris  | | | S1   | P5   |  100 | |
| +------+-------+---------+--------+ | | P6   | Cog   | Red    |  19.000 | London | | | S1   | P6   |  100 | |
|                                     | +------+-------+--------+---------+--------+ | | S2   | P1   |  300 | |
|                                     |                                              | | S2   | P2   |  400 | |
|                                     |                                              | | S3   | P2   |  200 | |
|                                     |                                              | | S4   | P2   |  200 | |
|                                     |                                              | | S4   | P4   |  300 | |
|                                     |                                              | | S4   | P5   |  400 | |
|                                     |                                              | +------+------+------+ |
+-------------------------------------+----------------------------------------------+------------------------+
</code></pre>

What is this? A relation that "contains" other relations; nothing spectacular in the TTM world, even if not usual with SQL. Truly relational approaches (and Alf, by the way) support values of arbitrary complexity. Let me illustrate this with one additional example:

<pre class="theory"><code class="ruby">$ alf --text extend suppliers -- chars "city.chars.to_a"
+------+-------+---------+--------+--------------------+
| :sid | :name | :status | :city  | :chars             |
+------+-------+---------+--------+--------------------+
| S1   | Smith |      20 | London | [L, o, n, d, o, n] |
| S2   | Jones |      10 | Paris  | [P, a, r, i, s]    |
| S3   | Blake |      30 | Paris  | [P, a, r, i, s]    |
| S4   | Clark |      20 | London | [L, o, n, d, o, n] |
| S5   | Adams |      30 | Athens | [A, t, h, e, n, s] |
+------+-------+---------+--------+--------------------+
</code></pre>

All examples in Alf documentation are based on this "database". Relation names are also magically resolved (as in the example above), so that you can learn quickly and easily. Of course, Alf is not limited to the *suppliers-and-parts* example. It actually recognizes various sources for base "relations".

### Manipulating .csv files

Alf recognizes .csv files as first class citizens. Download [books.csv](downloads/books.csv) and save it somewhere (credits to [parseomatic.com](http://www.parseomatic.com/parse/pskb/CSV-File-Format.htm)). Then try:

<pre class="theory"><code class="ruby">$ cd somewhere
$ alf show books.csv
+--------------+-----------------------------+------------+--------+
| :review_date | :author                     | :isbn      | :price |
+--------------+-----------------------------+------------+--------+
| 1985/01/21   | Douglas Adams               | 0345391802 | 5.95   |
| 1990/01/12   | Douglas Hofstadter          | 0465026567 | 9.95   |
| 1998/07/15   | Timothy The Parser Campbell | 0968411304 | 18.99  |
| ...          | ...                         | ...        | ...    |
</code></pre>

Oh, of course; .csv files are text files (observe that `:price` is aligned at left). Let see what we can do here (coercing `:review_date` to a Time is a bit contrived, but you've got the point!)

<pre class="theory"><code class="ruby">$ alf --text coerce books.csv -- review_date "Time" price "Float"
+---------------------------+-----------------------------+------------+--------+
| :review_date              | :author                     | :isbn      | :price |
+---------------------------+-----------------------------+------------+--------+
| 1985-01-21 00:00:00 +0100 | Douglas Adams               | 0345391802 |  5.950 |
| 1990-01-12 00:00:00 +0100 | Douglas Hofstadter          | 0465026567 |  9.950 |
| 1998-07-15 00:00:00 +0200 | Timothy The Parser Campbell | 0968411304 | 18.990 |
| ...                       | ...                         | ...        | ...    |
</code></pre>

Now that types are properly recognized, you may manipulate your data with the conjoined power of Alf and Ruby: 

<pre class="theory"><code class="ruby">$ alf coerce books.csv -- review_date "Time" | alf --text restrict -- "review_date.year == 2004"
+---------------------------+-------------------+------------+--------+
| :review_date              | :author           | :isbn      | :price |
+---------------------------+-------------------+------------+--------+
| 2004-10-04 00:00:00 +0200 | Benjamin Radcliff | 0804818088 |  4.950 |
| 2004-10-04 00:00:00 +0200 | Randel Helms      | 0879755725 |  4.500 |
+---------------------------+-------------------+------------+--------+
</code></pre>

I forgot to mention so far. The relational algebra is closed under its operators: they take relations as input, and return a relation. It shell, it means that Alf invocations can **always** be piped (in the example above, observe that the `--text` option has moved).

Talking about output options. Why not outputting query results in yaml or csv? 

<pre class="theory"><code class="yaml">$ alf coerce ... | alf --yaml restrict -- "review_date.year == 2004"
--- 
- :review_date: 2004-10-04 00:00:00 +02:00
  :author: Benjamin Radcliff
  :isbn: 0804818088
  :price: 4.95
- :review_date: 2004-10-04 00:00:00 +02:00
  :author: Randel Helms
  :isbn: 0879755725
  :price: 4.5
</code></pre>

### Connecting to SQL sources

Alf is also able to connect to SQL servers and SQLite files (provided that you install the `sequel` ruby library, as well as specific adapters: `pg`, `sqlite3`, and so on.). For example, suppose that you have a SQLite `northwind.db` file. Try this:

<pre class="theory"><code class="ruby">$ alf --env=northwind.db --text project customers -- Country
+-------------+
| :Country    |
+-------------+
| Germany     |
| Mexico      |
| UK          |
| Sweden      |
| France      |
| Spain       |
| Canada      |
| ...         |
</code></pre>

In the example above, the returned relation will never contain duplicate country names. Unlike SQL, here, relations are *sets*, not *bags*. The `project` operator automatically removes duplicates. 

Now, maybe you use a PostgreSQL database, or MySQL, etc.? No problem! Every DBMS supported by `sequel`, is supported by Alf (with credits to Jeremy Evans for such awesomeness):

<pre class="theory"><code class="ruby">$ alf --env=postgres://user:password@localhost:port/database --text project customers -- Country
+-------------+
| :Country    |
+-------------+
| Germany     |
| Mexico      |
| ...         |
</code></pre>



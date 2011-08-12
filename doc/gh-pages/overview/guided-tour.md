## Alf &mdash; Guided tour

Alf is shipped with example relations and is wired to them by default. The relations are based on the popular *suppliers-and-parts* example that C.J. Date uses in all his books (*S*, *P* and *SP* there are called `:suppliers`, `:parts` and `:supplies` here, respectively). Once Alf is installed, try this:

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

Of course, Alf is not limited to the *suppliers-and-parts* example, it recognizes various sources for base "relations".

* It recognizes .csv files as first class citizens. Download [books.csv](downloads/books.csv) and save it somewhere (credits to [parseomatic.com](http://www.parseomatic.com/parse/pskb/CSV-File-Format.htm)). Then try:

<pre class="theory"><code class="ruby">$ alf show books.csv
+--------------+-----------------------------+------------+--------+
| :review_date | :author                     | :isbn      | :price |
+--------------+-----------------------------+------------+--------+
| 1985/01/21   | Douglas Adams               | 0345391802 | 5.95   |
| 1990/01/12   | Douglas Hofstadter          | 0465026567 | 9.95   |
| 1998/07/15   | Timothy The Parser Campbell | 0968411304 | 18.99  |
| ...          | ...                         | ...        | ...    |
</code></pre>

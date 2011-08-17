## Using Alf to analyze logs

So, let first see if everything is ok. To check that Alf correctly recognizes the log file, we just ask him to show it as a relation. The `--pretty` option helper here keeping stuff readable by enabling wrapping and paging of the output:

<pre><code class="bash">$ alf --pretty show access.log

+-----------------+-----------------+-------+----------------+--------------+...
| :remote_host    | :remote_logname | :user | :timestamp     | :http_method |...
+-----------------+-----------------+-------+----------------+--------------+...
| 85.201.114.248  | [nil]           | [nil] | 20110814085806 | GET          |...
| 85.201.114.248  | [nil]           | [nil] | 20110814085818 | GET          |...
| 85.201.114.248  | [nil]           | [nil] | 20110814085821 | GET          |...
| 85.201.114.248  | [nil]           | [nil] | 20110814085821 | GET          |...
| 85.201.114.248  | [nil]           | [nil] | 20110814085821 | GET          |...
--- Press ENTER (or quit) ---
</code></pre>

Looks fine so far, except that some attributes have no value (nil is not a value). We will ignore this here, as we will not use those attributes. 

So, what are all available attributes? The `heading` operator aims at answering this simple request. It takes any relation as input and returns another relation containing only one tuple: the heading of its operand. Listed attributes give the universe of discourse, that is, what we are talking about:

<pre><code class="bash">$ alf --pretty heading access.log

{
  :remote_host => String,
  :remote_logname => NilClass,
  :user => NilClass,
  :timestamp => Bignum,
  :http_method => String,
  :path => String,
  :http_version => String,
  :http_status => Fixnum,
  :bytes_sent => Fixnum,
  :line_type => Symbol,
  :lineno => Fixnum,
  :source => NilClass
}
</code></pre>

Let's now start with a first query: *what is the number of hits per page/path?* The [`summarize`](shell/summarize.html) operator is dedicated to such queries, and ressemble to SQL's group by. In the example below, the summarize invocation can be rephased as follows:

<pre><code class="bash">% Summarize the access logs by `path`, add
%   - `hits` that count the number of times the page has been served
%   - `weight` that sums the number of bytes sent 
% We also show the resulting tuples in descending order of hits 

$ alf summarize access.log -- path -- hits "count()" weight "sum{ bytes_sent }" | \
  alf show -- hits desc

+-------------------------------------+-------+----------+
| :path                               | :hits | :weight  |
+-------------------------------------+-------+----------+
| /                                   |   470 |  2425971 |
| /css/1_jquery-ui-1.8.2.custom.css   |   322 |  4925692 |
| /css/2_style.css                    |   321 |   853516 |
| /js/0_jquery-1.4.2.min.js           |   314 | 11028238 |
| ...                                 | ...   | ...      |
</code></pre>

Hmmmm. Of course: index page, then css, then javascript, then images,... What if I'm only interrested in real *pages*? Just add a [restriction](shell/restrict.html) to your pipe! Here, we will make it roughly, through a simple regular expression:

<pre><code class="bash">% Given only pages that matches %r{...},
%  Summarize the access logs by `path`...

$ alf restrict access.log -- "path =~ %r{^/[a-zA-Z0-9_]+$}" | \
  alf summarize -- path -- hits "count()" weight "sum{ bytes_sent }" | \
  alf show -- hits desc

+--------------+-------+---------+
| :path        | :hits | :weight |
+--------------+-------+---------+
| /player      |   143 |  284120 |
| /onair       |    82 |  285543 |
| /playlist    |    66 |  246182 |
| ...          | ...   | ...     |
</code></pre>

Nice isn't? Let's try something else. In order to optimize the web site, it could be nice to know which served files are the most heavy. Not in absolute terms, but in terms of total weight served. So,

<pre><code class="bash">% First summarize over everything served,
%   - add a total weight computation, as before
% Rank the result on descending weight,
% And take the five heaviest requests

$ alf summarize access.log -- path -- weight "sum{ bytes_sent }" | \
  alf rank -- weight desc -- podium | \
  alf restrict -- "podium < 5" | \
  alf show -- ranking asc

+-------------------------------------+----------+---------+
| :path                               | :weight  | :podium |
+-------------------------------------+----------+---------+
| /images/banner.png                  | 32866403 |       0 |
| /js/1_jquery-ui-1.8.2.custom.min.js | 32153086 |       1 |
| /images/pubs/dancefloor.jpg         | 18943447 |       2 |
| /banner.swf                         | 15350202 |       3 |
| /js/0_jquery-1.4.2.min.js           | 11028238 |       4 |
+-------------------------------------+----------+---------+
</code></pre>


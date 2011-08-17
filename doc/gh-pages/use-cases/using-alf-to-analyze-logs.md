## Using Alf to analyze logs

So, let first see if everything is ok. To check that Alf correctly recognizes the log file, we just ask him to show it as a relation. The `--pretty` option helper here keeping stuff readable by enabling wrapping and paging of the output:

<pre><code class="terminal">$ alf show --pretty access.log

+-----------------+-----------------+-------+----------------+--------------+...
| :remote_host    | :remote_logname | :user | :timestamp     | :http_method |...
+-----------------+-----------------+-------+----------------+--------------+...
| 209.85.238.168  | [nil]           | [nil] | 20110710082919 | GET          |...
| 209.85.238.184  | [nil]           | [nil] | 20110710090716 | GET          |...
| 188.165.201.44  | [nil]           | [nil] | 20110710091931 | GET          |...
| 209.85.238.168  | [nil]           | [nil] | 20110710092310 | GET          |...
| 157.56.4.68     | [nil]           | [nil] | 20110710093902 | GET          |...
--- Press ENTER (or quit) ---
</code></pre>

Looks fine so far, except that some attributes have no value (nil is not a value). We will simply ignore this here by not using those attributes. 

So, what are all available attributes?

<pre><code class="terminal">$ alf heading access.log

{:remote_host => String, :remote_logname => NilClass, :user => NilClass,
 :timestamp => Bignum, :http_method => String, :path => String,
 :http_version => String, :http_status => Fixnum, :bytes_sent => Fixnum,
 :line_type => Symbol, :lineno => Fixnum, :source => NilClass}
</code></pre>




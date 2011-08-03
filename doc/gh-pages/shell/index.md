## Using Alf in shell

Alf provides a set of shell commands to manipulate data with relational algebra. Those commands are able to manipulate .csv files, SQL tables, log files, and so on. If you know ruby, writing an adapter for recognizing other data sources is almost straightforward.

<pre><code class="bash">
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
</code></pre>

As show below, Alf provides a fully-featured relational algebra.

<pre><code class="bash">
$ ./bin/alf --help

alf - Relational algebra at your fingertips

SYNOPSIS
  alf [--version] [--help] 
  alf -e '(lispy command)'
  alf [FILE.alf]
  alf [alf opts] OPERATOR [operator opts] ARGS ...
  alf help OPERATOR

OPTIONS
  -e, --execute                 Execute one line of script (Lispy API)
      --rash                    Render output as ruby hashes
      --text                    Render output as a text table
      --yaml                    Render output as a yaml output
      --csv                     Render output as a csv file
      --env=ENV                 Set the environment to use
      --input-reader=READER     Specify the kind of reader when reading on $stdin (rash,alf,csv,logs)
  -Idirectory                   Specify $LOAD_PATH directory (may be used more than once)
  -rlibrary                     Require the library, before executing alf
  -h, --help                    Show help
  -v, --version                 Show version

RELATIONAL OPERATORS
  project                   Relational projection (clip + compact)
  extend                    Relational extension (additional, computed attributes)
  rename                    Relational renaming (rename some attributes)
  restrict                  Relational restriction (aka where, predicate filtering)
  join                      Relational join (and cross-join)
  intersect                 Relational intersection (aka a logical and)
  minus                     Relational minus (aka difference)
  union                     Relational union
  matching                  Relational matching (join + project back on left)
  not-matching              Relational not matching (inverse of matching)
  wrap                      Relational wraping (tuple-valued attributes)
  unwrap                    Relational un-wraping (inverse of wrap)
  group                     Relational grouping (relation-valued attributes)
  ungroup                   Relational un-grouping (inverse of group)
  summarize                 Relational summarization (group-by + aggregate ops)
  rank                      Relational ranking (explicit tuple positions)

EXPERIMENTAL RELATIONAL OPERATORS
  quota                     Generalized quota-queries (position, sum progression, etc.)

NON-RELATIONAL OPERATORS
  autonum                   Extend its operand with an unique autonumber attribute
  defaults                  Force default values on missing/nil attributes
  compact                   Remove tuple duplicates
  sort                      Sort input tuples according to an order relation
  clip                      Clip input tuples to a subset of attributes
  coerce                    Force attribute coercion according to a heading

OTHER NON-RELATIONAL COMMANDS
  exec                      Executes an .alf file on current environment
  help                      Show help about a specific command
  show                      Output input tuples through a specific renderer (text, yaml, ...)

See 'alf help COMMAND' for details about a specific command.
</code></pre>


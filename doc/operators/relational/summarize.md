
Relational summarization (group-by + aggregate ops)

SYNOPSIS

  #{shell_signature}

OPTIONS
#{summarized_options}

DESCRIPTION

This operator summarizes input tuples over a projection given by BY_LIST.
SUMMARIZATION is a list of (name, aggregator) pairs.

With --allbut, the operator uses all attributes not in BY_LIST as 
projection key.

EXAMPLE

  alf summarize supplies -- sid -- total_qty "sum(:qty)" 
  alf summarize supplies --allbut -- pid qty -- total_qty "sum(:qty)" 



Relational summarization (group-by + aggregate ops)

SYNOPSIS

    #{signature}

OPTIONS

    #{summarized_options}

DESCRIPTION

This operator summarizes input tuples over a projection given by BY_LIST.
SUMMARIZATION is a list of (name, aggregator) pairs.

With --allbut, the operator uses all attributes not in BY_LIST as 
projection key.

EXAMPLE

    # Compute the sum of supplied quantities, by supplier id
    !{alf summarize supplies -- sid -- total_qty "sum(:qty)"}



Relational summarization (group-by + aggregate ops)

SYNOPSIS

    #(signature)

OPTIONS

    #(summarized_options)

DESCRIPTION

This operator summarizes input tuples over a projection given by BY. 
SUMMARIZATION is a mapping between attribute names and summarizing 
expressions.

With the allbut option, the operator uses all attributes not specified 
in BY as the projection key.

EXAMPLE

    # Compute the sum of supplied quantities, by supplier id
    !(alf summarize supplies -- sid -- total_qty "sum{ qty }")



Relational ranking (explicit tuple positions)

SYNOPSIS

    #(signature)

DESCRIPTION

This operator computes the ranking of input tuples, according to ORDER. 

Precisely, it extends its operand with an attribute called AS whose value 
is the number of tuples which are considered strictly less according to the
order relation denoted by ORDER.

Note that, unless the ordering includes a candidate key for the input relation, 
the new AS attribute is not necessarily a candidate key for the output. 

EXAMPLE

    # Rank parts by weight 
    !(alf rank parts -- weight -- position)

    # Rank parts by weight in descending order. Ensure that position is a 
    # candidate key by including a key in ordering
    !(alf rank parts -- weight desc pid asc -- position)


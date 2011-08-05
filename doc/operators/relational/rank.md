
Relational ranking (explicit tuple positions)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This operator computes the ranking of input tuples, according to ORDERING. 

Precisely, it extends its operand with a RANK_NAME attribute whose value 
is the number of tuples which are considered strictly less according to 
ORDERING. 

Note that, unless the ordering includes a candidate key for the input
relation, the newly RANK_NAME attribute is not necessarily a candidate key
for the output. 

EXAMPLE

    # Rank parts by weight 
    !{alf rank parts -- weight -- position}

    # Rank parts by weight in descending order. Ensure that position is a 
    # candidate key by including a key in ordering
    !{alf rank parts -- weight desc pid asc -- position}


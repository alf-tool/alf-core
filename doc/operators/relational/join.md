
Relational join (and cross-join)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This operator computes the (natural) join of its operands. 

Natural join means that, unlike what is commonly used in SQL, the join is 
performed on common attribute names. You can use the rename operator if 
this behavior does not fit your needs.

EXAMPLE

  alf join suppliers supplies 

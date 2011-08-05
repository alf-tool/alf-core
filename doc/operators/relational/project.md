
Relational projection (clip + compact)

SYNOPSIS

  #{shell_signature}

OPTIONS
#{summarized_options}

DESCRIPTION

This operator projects tuples on attributes whose names are specified in 
ATTR_LIST. Unlike SQL, this operator **always** removes duplicates in the
result so that the output is a set of tuples, that is, a relation.

With --allbut, the operators projects attributes in ATTR_LIST away instead 
of keeping them. 

EXAMPLE

  alf project suppliers -- name city
  alf project --allbut suppliers -- name city


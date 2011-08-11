
Force default values on missing/nil attributes

SYNOPSIS

    #(signature)

OPTIONS

    #(summarized_options)

DESCRIPTION

This non-relational operator rewrites input tuples to ensure that all values 
for attribute names specified in DEFAULTS are present and not nil. Missing or 
nil attributes are replaced by the specified default value.

A value specified in DEFAULTS may be any tuple expression. This allows computing 
the default value as an expression on the current tuple.

With the strict option, the operator projects resulting tuples on attributes for 
which a default value has been specified. Using the strict mode guarantees that 
the heading of all tuples is the same, and that no nil value ever remains. 

Note that this operator never removes duplicates. Even in strict mode the result 
might be an invalid relation. 

EXAMPLE

  alf defaults suppliers -- country "'Belgium'"
  alf defaults --strict suppliers -- country "'Belgium'"



Extend its operand with an unique autonumber attribute

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This non-relational operator guarantees uniqueness of output tuples by
adding an attribute ATTRNAME whose value is an auto-numbered Integer. 

If the presence of duplicates was the only "non-relational" aspect of 
the input, the result is a valid relation for which ATTRNAME is a 
candidate key.

EXAMPLE

  !{alf autonum suppliers}

  !{alf autonum suppliers -- unique_id}


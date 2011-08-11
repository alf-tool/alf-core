
Extend its operand with an unique autonumber attribute

SYNOPSIS

    #(signature)

DESCRIPTION

This non-relational operator guarantees uniqueness of output tuples by adding 
an attribute called AS whose value is an auto-numbered Integer. 

If the presence of duplicates was the only "non-relational" aspect of the input, 
the result is a valid relation for which AS is a candidate key.

EXAMPLE

    # Autonumber suppliers with default attribute name
    !(alf autonum suppliers)

    # Autonumber suppliers with a `unique_id` attribute
    !(alf autonum suppliers -- unique_id)


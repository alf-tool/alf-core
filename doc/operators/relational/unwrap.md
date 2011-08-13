
Relational un-wrapping (inverse of wrap)

SYNOPSIS

    #(signature)

DESCRIPTION

This operator flattens its operand by unwrapping the tuple-valued 
attribute ATTR.

EXAMPLE

    # Given, `city` and `status` wrapped as `loc_and_status` 
    !(alf wrap suppliers -- city status -- loc_and_status)

    # Let's unwrap them
    !(alf wrap suppliers -- city status -- loc_and_status | alf unwrap -- loc_and_status)


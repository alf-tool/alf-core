
Relational wrapping (tuple-valued attributes)

SYNOPSIS

    #(signature)

OPTIONS

    #(summarized_options)

DESCRIPTION

This operator wraps attributes in ATTRIBUTES as a new, tuple-valued attribute 
named AS.

With the allbut option, it wraps all attributes not specified in ATTRIBUTES 
instead.

EXAMPLE

    # Wrap `city` and `status` and a tuple-value attribute named `loc_and_status` 
    !(alf wrap suppliers -- city status -- loc_and_status)


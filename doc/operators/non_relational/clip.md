
Clip input tuples to a subset of attributes

SYNOPSIS

    #(signature)

OPTIONS

    #(summarized_options)

DESCRIPTION

This operator clips tuples on attributes whose names are specified in 
ATTRIBUTES. This is similar to the relational PROJECT operator, expect 
that CLIP does not remove duplicates afterwards.

Clipping may therefore lead to bags of tuples instead of sets. The result
is therefore **not** a valid relation unless a candidate key is preserved.

With the allbut option, the operator keeps attributes in ATTRIBUTES, instead 
of projecting them away. 

EXAMPLE

    # Clip suppliers on `name` and `city`
    !(alf clip suppliers -- name city)

    # Clip suppliers on all other attributes
    !(alf clip suppliers --allbut -- name city)


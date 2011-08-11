
Relational grouping (relation-valued attributes)

SYNOPSIS

    #(signature)

OPTIONS

    #(summarized_options)

DESCRIPTION

This operator groups attributes in ATTRIBUTES as a new, relation-valued 
attribute named AS.

With the allbut option, it groups all attributes not specified in ATTRIBUTES
instead.

EXAMPLE

    # Group pid and qty as a relation-valued attribute names supplying
    !(alf group supplies -- pid qty -- supplying)

    # Group all but pid ...
    !(alf group supplies --allbut -- pid -- supplying)


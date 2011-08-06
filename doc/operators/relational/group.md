
Relational grouping (relation-valued attributes)

SYNOPSIS

    #{shell_signature}

OPTIONS

    #{summarized_options}

DESCRIPTION

This operator groups attributes in ATTR_LIST as a new, relation-valued
attribute named AS.

With --allbut, it groups all attributes not specified in ATTR_LIST instead.

EXAMPLE

    # Group pid and qty as a relation-valued attribute names supplying
    !{alf group supplies -- pid qty -- supplying}

    # Group all but pid ...
    !{alf group supplies --allbut -- pid -- supplying}


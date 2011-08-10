
Generates a relation with an auto-numbered attribute

SYNOPSIS

    #{signature}

DESCRIPTION

This non-relational operator generates a relation containing an attribute 
ATTR_NAME whose value is an auto-number from 1 to SIZE.

EXAMPLE

    # Default behavior: ATTR_NAME is `num` and SIZE is 10
    !{alf generator}

    # That you can override
    !{alf generator -- 5 -- id}


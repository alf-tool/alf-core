
Generate a relation with an auto-numbered attribute

SYNOPSIS

    #(signature)

DESCRIPTION

This non-relational operator generates a relation of one attribute called AS, 
whose value is an auto-number ranging from 1 to SIZE, inclusively.

EXAMPLE

    # Default behavior: AS is `num` and SIZE is 10
    !(alf generator)

    # That you can override
    !(alf generator -- 5 -- id)



Relational un-grouping (inverse of group)

SYNOPSIS

    #(signature)

DESCRIPTION

This operator flattens its operand by ungrouping the relation-valued 
attribute ATTR. 

EXAMPLE

    # Given `pid` and `qty` groupped as `supplying`
    !(alf group supplies -- pid qty -- supplying)

    # Let's ungroup them
    !(alf group supplies -- pid qty -- supplying | alf ungroup -- supplying)


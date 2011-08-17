
Relational join (and cartesian product)

SYNOPSIS

    #(signature)

DESCRIPTION

This operator computes the (natural) join of its operands. 

Natural join means that, unlike what is commonly used in SQL, joining is based 
on equality of all attributes that are shared between LEFT and RIGHT performed 
on common attribute names. You can use the `rename` operator if this  behavior 
does not fit your needs.

When operands have no attribute in common, this operator naturally "degenerates" 
to a cartesian product.

EXAMPLE

    # Computes natural join of suppliers and supplies (on sid, the only 
    # attribute they have in common)
    !(alf join suppliers supplies)

    # The following example demontrates the cartesian product with a generated 
    # relation
    !(alf generator -- 3 -- num | alf join cities)


Relational heading inference (print the relation type)

SYNOPSIS

    #(signature)

DESCRIPTION

This operator simply outputs a relation containing one tuple: the heading of 
its operand. 

EXAMPLE

    # What is the heading of the `suppliers` relation?
    !(alf infer-heading suppliers)

    # What is the heading of the following join?
    !(alf join suppliers supplies | alf infer-heading)


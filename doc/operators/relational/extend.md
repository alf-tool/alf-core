
Relational extension (additional, computed attributes)

SYNOPSIS

    #(signature)

DESCRIPTION

This operator extends its operand with new attributes whose value is the result 
of evaluating tuple expressions specified in EXT. The latter are specified as 
(name, expression) pairs.

EXAMPLE

    # Compute a few attributes on suppliers by extension
    !(alf extend supplies -- big "qty > 100"  price "qty * 12.2")


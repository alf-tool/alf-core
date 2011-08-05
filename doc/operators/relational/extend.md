
Relational extension (additional, computed attributes)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This operator extends its operand with new attributes whose value is the 
result of evaluating tuple expressions. The latter are specified as 
(name, tuple expression) pairs. Tuple expressions must be specified as 
ruby code literals. 

EXAMPLE

  alf extend supplies -- big "qty > 100"  price "qty * 12.2"


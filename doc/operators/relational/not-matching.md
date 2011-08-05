
Relational not matching (inverse of matching)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This operator restricts LEFT tuples to those for which there does not 
exist any tuple in RIGHT that (naturally) joins. This is a shortcut 
operator for the following longer expression: 

        (minus xxx, (matching xxx, yyy))

EXAMPLE

  alf not-matching suppliers supplies


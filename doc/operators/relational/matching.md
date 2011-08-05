
Relational matching (join + project back on left)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This operator restricts its LEFT operand to tuples for which there exists 
at least one tuple in RIGHT that (naturally) joins. This is a shortcut 
operator for the following longer expression:

  (project (join xxx, yyy), [xxx's attributes])

EXAMPLE

  alf matching suppliers supplies 


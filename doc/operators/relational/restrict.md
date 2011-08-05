
Relational restriction (aka where, predicate filtering)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This command restricts tuples to those for which PREDICATE evaluates to 
true.

PREDICATE must be a valid tuple expression that returns a truth-value.
It may be specified as a ruby code literal, or a list of (name, value)
pairs. In the latter case, PREDICATE is built as a conjunction of 
attribute equalities.

EXAMPLE

  alf restrict suppliers -- "status > 20"
  alf restrict suppliers -- city "'London'"


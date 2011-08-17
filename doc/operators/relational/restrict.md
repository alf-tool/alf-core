
Relational restriction (aka where, predicate filtering)

SYNOPSIS

    #(signature)

DESCRIPTION

This command restricts restricts relations to those tuples for which PREDICATE 
evaluates to true.

PREDICATE must be a valid tuple expression that returns a truth-value. It 
may be specified as a ruby code literal, or a mapping between (name, value) 
pairs. In the latter case, PREDICATE is built as a conjunction of attribute 
equalities.

EXAMPLE

    # Who are suppliers with a status greater than 20?
    !(alf restrict suppliers -- "status > 20")

    # Which suppliers live in London?
    !(alf restrict suppliers -- city "'London'")


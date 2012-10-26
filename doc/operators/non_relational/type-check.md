
Type checks input tuples against a specific heading

SYNOPSIS

    #(signature)

DESCRIPTION

This non-relational ensures that input tuples match a given heading (in strict mode),
or a projection (in non-strict mode). This is useful when connecting to data-sources whose
relation representations must absolutely be checked for type safety.

EXAMPLE

  # Check that the suppliers have the correct heading (since is missing, but ok)
  !(alf type-check suppliers -- sid String name String status Integer city String since Date)

  # Strict, no attribute can be missing
  !(alf type-check --strict suppliers -- sid String name String status Integer city String)

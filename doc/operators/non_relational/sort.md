
Sort input tuples according to an order relation

SYNOPSIS

    #(signature)

DESCRIPTION

This non-relational operator sorts input tuples according to ORDERING. 

This is, of course, a non relational operator as relations are unordered 
sets. It is provided for displaying purposes and normalization of 
non-relational inputs.

EXAMPLE

  # Sort suppliers by name
  !(alf sort suppliers -- name asc)

  # Sort suppliers by city in descending order, then on name on ascending 
  # order
  !(alf sort suppliers -- city desc name asc)


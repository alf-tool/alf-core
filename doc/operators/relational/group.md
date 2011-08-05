
Relational grouping (relation-valued attributes)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

This operator groups attributes in ATTR_LIST as a new, relation-valued
attribute named AS.

With --allbut, it groups all attributes not specified in ATTR_LIST instead.

EXAMPLE

  alf group supplies -- pid qty -- supplying
  alf group supplies --allbut -- sid -- supplying


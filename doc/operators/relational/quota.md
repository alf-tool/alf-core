
Generalized quota-queries (position, sum progression, etc.)

SYNOPSIS

  #{shell_signature}

DESCRIPTION

**This operator is a work in progress and should be used with care.**

This operator is an attempt to generalize RANK in two ways:
  * Use a full SUMMARIZATION instead of hard-coding a ranking attribute 
    through count()
  * Providing a BY key so that sumarizations can actually be done on 
    sub-groups

EXAMPLE

  alf quota supplies -- sid -- qty -- position count sum_qty "sum(:qty)"


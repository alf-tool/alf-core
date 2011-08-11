
Generalized quota-queries (position, sum progression, etc.)

SYNOPSIS

    #(signature)

DESCRIPTION

**This operator is a work in progress and should be used with care.**

This operator is an attempt to generalize RANK in two directions:

* Use a full SUMMARIZATION instead of hard-coding a ranking attribute via count()
* Providing a BY key so that summarizations can actually be done on sub-groups

EXAMPLE

    # Compute linear progression of quantities by supplier number
    !(alf quota supplies -- sid -- qty -- position count  sum_qty "sum{ qty }")


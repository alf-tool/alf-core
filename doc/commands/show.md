
Output input tuples through a specific renderer (text, yaml, ...)

SYNOPSIS

    alf #(command_name) NAME -- [ORDERING]

OPTIONS

    #(summarized_options)

DESCRIPTION

When a name is specified as commandline arg, request the database to
provide the corresponding relation variable and prints its value.
Otherwise, take what comes on standard input.

Note that this command is not an operator and should not be piped
anymore.

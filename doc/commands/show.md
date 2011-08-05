
Output input tuples through a specific renderer (text, yaml, ...)

SYNOPSIS
  alf #{command_name} DATASET

OPTIONS
#{summarized_options}

DESCRIPTION

When a dataset name is specified as commandline arg, request the 
environment to provide this dataset and prints it. Otherwise, take what 
comes on standard input.

Note that this command is not an operator and should not be piped anymore.


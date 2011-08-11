
Relational renaming (rename some attributes)

SYNOPSIS

    #(signature)

DESCRIPTION

This command renames attributes as specified in RENAMING, taken as successive 
(old name, new name) pairs

EXAMPLE

    # Rename a few supplier attributes
    !(alf rename suppliers -- name supplier_name  city supplier_city)


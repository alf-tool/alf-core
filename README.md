# Alf

Classy data-manipulation dressed in a DSL (+ commandline)

    [sudo] gem install alf
    alf --help

# Description

Alf is a commandline tool and Ruby API to manipulate data with all the power of
a truly relational algebra approach. Objectives behind Alf are manifold:

* Pragmatically, Alf aims at being a useful commandline executable for 
  manipulating csv files, database records, or whatever looks like a relation
  (see below). See 'alf --help' for the list of available commands.
  
* Also, a 100% Ruby API provides a simple, functional in style, relational 
  algebra that manipulates enumerables of tuples (represented by ruby hashes).
  See 'alf --help' as well as .alf files in the examples directory for syntactic 
  examples.

* Alf is also an educational tool, that I've written to draw people's attention
  about the ill-known relational theory (and ill-represented by SQL). The tool
  is largely inspired from TUTORIAL D, the tutorial language of Chris Date 
  and Hugh Darwen in their books, more specifically in The Third Manifesto 
  (TTM). However, in itself, the present little tool is only an overview of the 
  relational algebra described there. I hope that some people will be sufficiently 
  enticed by specific features here to open that book and read it more deeply.
  Have a look at 'alf help group / summarize / quota' for things that you'll  
  never ever have in SQL. 
  
* Alf is also an attempt to help me test some research ideas and communicate 
  about them with people that already know (all or part) of the TTM vision of 
  relational theory. These people include members of the TTM mailing list as
  well as other people implementing some of the TTM ideas (see Dan Kubb's Veritas 
  project for example). For this reason, specific features and/or operators are 
  mine (quota, for example is not present in TUTORIAL D) and should be considered 
  'work in progress' and used with care...

# Getting started with commandline

    alf --help

The help command will display the list of available operators. Each of them is
completely described with 'alf help OPERATOR'. They all have a similar invocation
syntax in shell:

    alf --input=operand1,operand2,... OPERATOR args...

For examples, you can try the following (display suppliers that live in Paris):

    alf --input=suppliers restrict "city == 'Paris'"
    
For educational purposes, the 'suppliers' input is magically resolved as denoting
the file examples/suppliers.rash. You'll find other data files: parts.rash, 
supplies.rash and cities.rash that are resolved magically as well, and with which
you can play. For more friendly output, try the following:

    # the show command renders a text table by default
    alf show [--text] suppliers
    
    +------+-------+---------+--------+
    | :sid | :name | :status | :city  |
    +------+-------+---------+--------+
    | S1   | Smith |      20 | London |
    | S2   | Jones |      10 | Paris  |
    | S3   | Blake |      30 | Paris  |
    | S4   | Clark |      20 | London |
    | S5   | Adams |      30 | Athens |
    +------+-------+---------+--------+

    # and reads from standard input without argument!  
    alf --input=suppliers restrict "city == 'Paris'" | alf show

    +------+-------+---------+-------+
    | :sid | :name | :status | :city |
    +------+-------+---------+-------+
    | S2   | Jones |      10 | Paris |
    | S3   | Blake |      30 | Paris |
    +------+-------+---------+-------+
    
You'll also find .alf files in the examples folder, that contains more complex
examples in the Ruby functional syntax (see below). You can simply execute these
files with alf directly as follows:

    # the following works, as well as the shortcut 'alf show group'
    alf examples/group.alf | alf show 
    
    +------+-----------------+
    | :sid | :supplying      |
    +------+-----------------+
    | S1   | +------+------+ |
    |      | | :pid | :qty | |
    |      | +------+------+ |
    |      | | P1   |  300 | |
    |      | | P2   |  200 | |
    ...
    
For more information about recognized data files (.rash, .yaml, ...), output
formats and .alf executable commands, read on!

# Getting started with .alf files and Ruby API

If you tke a look at .alf example files, you'll find functional ruby expressions
like the following (examples/minus.alf):

    # Give all suppliers, except those living in Paris
    (minus :suppliers, 
           (restrict :suppliers, lambda{ city == 'Paris' }))
    
    # This is a contrived example for illustrating minus, as the
    # following is equivalent
    (restrict :suppliers, lambda{ city != 'Paris' })
    
You can simply execute such expressions with alf command line itself:
 
    alf examples/minus.alf | alf show
    alf -e "(restrict :suppliers, lambda{ city != 'Paris' })" | alf show

For now, the Ruby API is documented in the commandline help itself. For example, 
you'll find the allowed syntaxes for RESTRICT as follows:

    alf help restrict
    
    ...
    API & EXAMPLE
    
      # Restrict to suppliers with status greater than 20
      (restrict :suppliers, lambda{ status > 20 })
    
      # Restrict to suppliers that live in London
      (restrict :suppliers, lambda{ city == 'London' })
    ...
    
Of course, from the closure property of a relational algebra (that states that
operators works on relations and return relations), you can use a sub expression 
*everytime* a relational operand is expected, everytime! Symbols are magically 
resolved from the environment, which is wired to the examples by default. 
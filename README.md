# Alf - Classy data-manipulation dressed in a DSL (+ commandline)

    [sudo] gem install alf
    alf --help

## Description

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
  Have a look at 'alf help group / summarize / quota' for things that you'll never 
  ever have in SQL. 
  
* Alf is also an attempt to help me test some research ideas and communicate 
  about them with people that already know (all or part) of the TTM vision of 
  relational theory. These people include members of the TTM mailing list as
  well as other people implementing some of the TTM ideas (see Dan Kubb's Veritas 
  project for example). For this reason, specific features and/or operators are 
  mine (quota, for example is not present in TUTORIAL D) and should be considered 
  'work in progress' and used with care...

## Getting started with commandline

    alf --help

The help command will display the list of available operators. Each of them is
completely described with 'alf help OPERATOR'. They all have a similar invocation
syntax in shell:

    alf operator operands... -- args...

For example, try the following:

    # display suppliers that live in Paris
    alf restrict suppliers -- "city == 'Paris'"
    
    # join suppliers and cities (no args here)
    alf join suppliers cities
    
For educational purposes, 'suppliers' and 'cities' inputs are magically resolved 
as denoting the files examples/suppliers.rash and examples/cities.rash, respectively. 
You'll find other data files: parts.rash, supplies.rash that are resolved magically 
as well and with which you can play.

Unary operators read their operand on standard input when not specified. For example, 
the invocation below is equivalent to the one given above.

    # display suppliers that live in Paris
    cat examples/suppliers.rash | alf restrict -- "city == 'Paris'"  

Similarly, when only one operand is present in invocations of binary operators, 
they read their left operand from standard input. Therefore, the join given above 
can also be written as follows:

    cat examples/suppliers.rash | alf join cities

The relational algebra is _closed_ under its operators, which means that these 
operators take relations as operands and return a relation. Therefore operator 
invocations can be nested, that is, operands can be other relational expressions. 
When you use alf in a shell, it simply means that you can pipe operators as you 
want:

    alf show --rash suppliers | alf join cities | alf restrict -- "status > 10"

### Obtaining a friendly text output, or yaml files, etc.

The show command (which is **not** a relational operator) can be used to obtain
a more friendly output:

    # it renders a text table by default
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
    alf restrict suppliers "city == 'Paris'" | alf show

    +------+-------+---------+-------+
    | :sid | :name | :status | :city |
    +------+-------+---------+-------+
    | S2   | Jones |      10 | Paris |
    | S3   | Blake |      30 | Paris |
    +------+-------+---------+-------+

Other formats can be obtained (see 'alf help show'). For example, you can generate
a .yaml file, as follows: 

    alf restrict suppliers -- "city == 'Paris'" | alf show --yaml

### Executing .alf files and expressions

You'll also find .alf files in the examples folder, that contain more complex
examples in the Ruby functional syntax (see section below). You can simply 
execute these files with alf directly as follows:

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
    
Also, mimicing the ruby executable, the following invocation is also possible:

    alf -e "(restrict :suppliers, lambda{ city == 'Paris' })"

where the argument is a relational expression in Alf's Lispy dialect, which
is detailed in the next section.

## Getting started with the Ruby API

### Calling commands 'ala' shell

For simple cases, the easiest way of using Alf in ruby is probably to mimic
what you have in shell:

    # in shell
    alf restrict suppliers -- "city == 'Paris'"
    
    # in ruby 
    #   - create an engine on an environment (see section about environments later)
    #   - run a command 
    #   - op is a thread-safe enumerable of tuples, see the Lispy section below)
    #
    lispy = Alf.lispy(Alf::Environment.examples)
    op = lispy.run(['restrict', 'suppliers', '--', "city == 'Paris'"])

If this kind of API is not sufficiently expressive for you, you'll have to learn 
the APIs deeper, for example with the Lispy functional style that Alf provides, 
and which is covered in next section.

### Lispy expressions

If you take a look at .alf example files, you'll find functional ruby expressions
like the following (examples/minus.alf):

    # Give all suppliers, except those living in Paris
    (minus :suppliers, 
           (restrict :suppliers, lambda{ city == 'Paris' }))
    
    # This is a contrived example for illustrating minus, as the
    # following is equivalent
    (restrict :suppliers, lambda{ city != 'Paris' })
    
You can simply execute such expressions with the alf command line itself (the 
three following invocations return the same result):
 
    alf examples/minus.alf | alf show
    alf show minus
    alf -e "(restrict :suppliers, lambda{ city != 'Paris' })" | alf show

Symbols are magically resolved from the environment, which is wired to the 
examples by default. Of course, from the closure property of a relational algebra 
(that states that operators works on relations and return relations), you can 
use a sub expression *everytime* a relational operand is expected, everytime:

    # Give the maximal supplied quantity by country, taking only into account
    # suppliers that have a status greater than 10
    (summarize \
      (join \
        (join (restrict :suppliers, lambda{ status > 10 }), 
              :supplies), 
        :cities),
      [:country], 
      :maxqty => Aggregator.sum{ qty })

#### Going further

For now, the Ruby API is documented in the commandline help itself (a cheatsheet
or something will be provided as soon as possible). For example, you'll find the 
allowed syntaxes for RESTRICT as follows:

    alf help restrict
    
    ...
    API & EXAMPLE
    
      # Restrict to suppliers with status greater than 20
      (restrict :suppliers, lambda{ status > 20 })
    
      # Restrict to suppliers that live in London
      (restrict :suppliers, lambda{ city == 'London' })
    ...

### Interfacing in Ruby

If you want to use Alf in ruby directly (that is, not in shell or by executing
.alf files), you can simply compile expressions and use resulting operators as 
follows:

    # 
    # We use the examples environment below, see the section below about other 
    # available environments.
    #
    # Op is an enumerable of ruby hashes (used as physical representation
    # of tuples). Provided that terminal inputs offered by the environment
    # (:suppliers here) can be enumerated more than once, the operator may be 
    # used multiple times and is even thread safe!  
    #
    op = Alf.lispy(Alf::Environment.examples).compile do
      (restrict :suppliers, lambda{ city == 'London' })
    end


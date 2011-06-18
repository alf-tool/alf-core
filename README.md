# Alf - Classy data-manipulation dressed in a DSL (+ commandline)

    % [sudo] gem install alf
    % alf --help

## Links
    
* {http://rubydoc.info/github/blambeau/alf/master/frames} (read this file there!)
* {http://github.com/blambeau/alf} (source code)
* {http://revision-zero.org} (author)

## Description

Alf is a commandline tool and Ruby library to manipulate data with all the power 
of a truly relational algebra approach. Objectives behind Alf are manifold:

* Pragmatically, Alf aims at being a useful commandline executable for 
  manipulating csv files, database records, or whatever looks like a relation.
  See 'alf --help' for the list of available commands and implemented relational 
  operators.
  
      % alf restrict suppliers -- "city == 'London'" | alf join cities 
  
* Alf is also a 100% Ruby relational algebra implementation shipped with a simple 
  to use, powerful, functional DSL for compiling and evaluating relational queries. 
  Alf does not restrict to simple scalar types or values, but admit values of
  arbitrary complexity (under a few requirements about their implementation, see 
  next section). See 'alf --help' as well as .alf files in the examples directory 
  for syntactic examples.
  
      Alf.lispy.compile{ 
        (join (restrict :suppliers, lambda{ city == 'London' }), :cities)
      }

* Alf is also an educational tool, that I've written to draw people's attention
  about the ill-known relational theory (and ill-represented by SQL). The tool
  is largely inspired from TUTORIAL D, the tutorial language of Chris Date and 
  Hugh Darwen in their books, more specifically in 
  {http://www.thethirdmanifesto.com/ The Third Manifesto (TTM)}. 
  However, in itself, the present little tool is only an overview of the 
  relational _algebra_ described there (Alf is neither a relational _database_, 
  nor a relational _language_). I hope that some people will be sufficiently 
  enticed by specific features here to open that book and read it more deeply. 
  Have a look at the result of the following query for things that you'll never 
  ever have in SQL (see also 'alf help quota', 'alf help nest', 'alf help group', 
  ...):
  
      % alf --text summarize supplies --by=sid -- total "sum(:qty)" -- which "group(:pid)"
  
* Last, but not least, Alf is an attempt to help me test some research ideas and 
  communicate about them with people that already know (all or part) of the TTM 
  vision of relational theory. These people include members of the TTM mailing 
  list as well as other people implementing some of the TTM ideas (see Dan Kubb's 
  Veritas project for example). For this reason, specific features and/or operators 
  are mine, should be considered 'research work in progress', and used with care
  because not necessarily in conformance with the TTM.
  
      % alf --text quota supplies --by=sid --order=quantity -- pos "count()"  

## Overview of relational theory

We quickly recall relational theory in this section, as described in the TTM 
book. Readers not familiar with Date and Darwen's vision of relational theory 
should probably read this section, even if fluent in SQL. Others may probably
skip this section. A quick test? 

> _A relation is a a value, precisely a set of tuples. Therefore, it is 
  immutable, not ordered, does not contain duplicates, and does not have 
  null/nil attributes._ 
  
Familiar? Skip. Otherwise, read on.

### The example database

This README file shows a lot of examples built on top of the following suppliers 
& parts database (almost identical to the original version in C.J. Date database 
books). By default, the alf command line is wired to this embedded example. All
examples shown here should therefore work immediately. Then, let's start!

    % alf show database

    +-------------------------------------+-------------------------------------------------+-------------------------+------------------------+
    | :suppliers                          | :parts                                          | :cities                 | :supplies              |
    +-------------------------------------+-------------------------------------------------+-------------------------+------------------------+
    | +------+-------+---------+--------+ | +------+-------+--------+------------+--------+ | +----------+----------+ | +------+------+------+ |
    | | :sid | :name | :status | :city  | | | :pid | :name | :color | :weight    | :city  | | | :city    | :country | | | :sid | :pid | :qty | |
    | +------+-------+---------+--------+ | +------+-------+--------+------------+--------+ | +----------+----------+ | +------+------+------+ |
    | | S1   | Smith |      20 | London | | | P1   | Nut   | Red    | 12.0000000 | London | | | London   | England  | | | S1   | P1   |  300 | |
    | | S2   | Jones |      10 | Paris  | | | P2   | Bolt  | Green  | 17.0000000 | Paris  | | | Paris    | France   | | | S1   | P2   |  200 | |
    | | S3   | Blake |      30 | Paris  | | | P3   | Screw | Blue   | 17.0000000 | Oslo   | | | Athens   | Greece   | | | S1   | P3   |  400 | |
    | | S4   | Clark |      20 | London | | | P4   | Screw | Red    | 14.0000000 | London | | | Brussels | Belgium  | | | S1   | P4   |  200 | |
    | | S5   | Adams |      30 | Athens | | | P5   | Cam   | Blue   | 12.0000000 | Paris  | | +----------+----------+ | | S1   | P5   |  100 | |
    | +------+-------+---------+--------+ | | P6   | Cog   | Red    | 19.0000000 | London | |                         | | S1   | P6   |  100 | |
    |                                     | +------+-------+--------+------------+--------+ |                         | | S2   | P1   |  300 | |
    |                                     |                                                 |                         | | S2   | P2   |  400 | |
    |                                     |                                                 |                         | | S3   | P2   |  200 | |
    |                                     |                                                 |                         | | S4   | P2   |  200 | |
    |                                     |                                                 |                         | | S4   | P4   |  300 | |
    |                                     |                                                 |                         | | S4   | P5   |  400 | |
    |                                     |                                                 |                         | +------+------+------+ |
    +-------------------------------------+-------------------------------------------------+-------------------------+------------------------+

Many people think that relational databases are necessary 'flat', that they are 
necessarily limited to simply scalar values in two dimension tables. This is 
wrong; most SQL databases are indeed 'flat', but _relations_ (in the mathematical 
sense of the relational theory) are not! Look, **the example above is a relation!**; 
that 'contains' another relations as particular values, which, in turn, could 
'contain' relations or any other 'simple' or more 'complex' value... This is not 
"flat" at all, after all :-)

### Types and Values

To understand what is a relation exactly, one needs to remember elementary 
notions of set theory and the concepts of _type_ and _value_. 

* A _type_ is a finite set of values; it is non particularly ordered and, being 
a set, it does never contains two values which are considered equal.  

* A _value_ is **immutable** (you cannot 'change' a value, in any way), has no 
localization in time and space, and is always typed (that is, it is always 
accompanied by some identification of the type it belongs to). 
 
As you can see, _type_ and _value_ are not the same concepts as _class_ and 
_object_, with which you are probably familiar with. Alf considers that the 
latter are implementations of the former. Alf assumes _valid_ implementations, 
(equality and hash methods must be correct) and _valid_ usage (objects used for
representing values are kept immutable). That being said, if you want **arrays, 
colors, ranges, or whatever in your relations**, just do it! You can even join 
on them, restrict on them, summarize on them, and so on:

    % alf extend suppliers -- chars "name.chars.to_a" | alf --text restrict -- "chars.last == 's'"

    +------+-------+---------+--------+-----------------+
    | :sid | :name | :status | :city  | :chars          |
    +------+-------+---------+--------+-----------------+
    | S2   | Jones |      10 | Paris  | [J, o, n, e, s] |
    | S5   | Adams |      30 | Athens | [A, d, a, m, s] |
    +------+-------+---------+--------+-----------------+

A last, very important word about values. **Null/nil is not a value**. Strictly
speaking therefore, you may not use null/nil inside your data files or datasources 
representing relations. That being said, Alf provides specific support for 
handling them, as they appear in today's databases. See the section with title 
"Why is Alf Exactly?" later.

### Tuples and Relations

Tuples (aka records) and relations are values as well, which explains why you
can have them inside relations! 

* Logically speaking, a tuple is a set of (attribute name, attribute value) 
  pairs. Moreover, it does not contain two attributes with the same name and is 
  **not particularly ordered**. Also, **a tuple is a _value_, and is therefore 
  immutable**. Last, but not least, a tuple does not admit nulls/nils. Tuples in 
  Alf are simply implemented with ruby hashes, taken as tuples implementations. 
  Alf does not freeze them for guaranteeing immutability, but could do it in the 
  future. No support is or will ever be provided for ordering tuple attributes. 
  Because hashes are ordered in Ruby 1.9, Alf implements a best effort strategy 
  to keep a friendly ordering when rendering tuples. This is a very good practical 
  reason for migrating to ruby 1.9 if not already done!

      {:sid => "S1", :name => "Smith", :status => 20, :city => "London"}

* A _relation_ is a set of tuples. Being a set, a relation does **never contain
  duplicates** (unlike SQL that works on bags, not on sets) and is **not 
  particularly ordered**. Moreover, all tuples of a relation must have the same
  _heading_, that is, the same set of attribute (name, type) pairs. Also, **a 
  relation is a _value_, and is therefore immutable**. Last but not least, 
  relations do not admit nulls/nils.
  
Alf provides no way to 'change' a relation in any way, but it provides an algebra 
to compute relations from other relations.
  
### Relational Algebra

In classical algebra, you can do computations like <code>(5 + 2) - 3</code>. In 
relational algebra, you can do similar things on relations. Alf uses an an infix, 
functional programming-oriented syntax: 
  
    (minus (union :suppliers, xxx), yyy)
    
All relational operators take relation operands in input and return a relation 
as output. We say that the relational algebra is _closed_ under its operators.
In practice, it means that operands may always be sub-expressions, **always**.

    (minus (union (restrict :suppliers, lambda{ zzz }), xxx), yyy)

In shell, the closure property means that you can pipe alf invocations the way 
you want! The same query, in shell:

    alf restrict suppliers -- "zzz" | alf union xxx | alf minus yyy
    
## What is Alf exactly?   

The Third Manifesto defines a series of prescriptions, proscriptions and very 
strong suggestions for designing a truly relational _language_, called a _D_, 
as an alternative to SQL for managing relational databases. This is far behind
our objective with Alf, as we don't look at database aspects at all (persistence
transactions, and so on.) and don't actually define a programming language either 
(only a small functional ruby DSL). 

Alf must simply be interpreted as a ruby library implementing a variant of Date's
and Darwen relational algebra. This library is designed as a set of operator 
implementations, that work as tuple iterators taking other tuple iterators as 
input. Under the pre-condition that you provide them _valid_ tuple iterators as 
input (no duplicates, no nil, + other preconditions on an operator basis), the 
result is a valid iterator as well. Unless explicitely stated otherwise, any
behavior observed when not respecting these precondition rules, even interesting 
behavior, is not guaranteed and can change with tiny library version changes.

### In ruby

    # 
    # Provided that :suppliers and :cities are valid relation representations
    # (under the responsibility shared by you and the Reader and Environment 
    # subclasses you use -- see later),  then, 
    # 
    op = Alf.lispy.compile{ 
      (join (restrict :suppliers, lambda{ city == 'London' }), :cities)
    }
    
    # op is a thread-safe Enumerable of tuples, that can be taken as a valid
    # relation representation. It can therefore be used as the input operand 
    # of any other expression. This is under Alf's responsibility, and any 
    # failure must be considered a bug!

### In shell

    #
    # Provided that suppliers and cities are valid relation representations
    # [something similar] 
    #
    % alf restrict suppliers -- "city == 'London'" | alf join cities

    # the resulting stream is a valid relation representation in the output
    # stream format that you have selected (.rash by default). It can therefore 
    # be piped to another alf shell invocation, or saved to a file and re-read
    # later (under the assumption that input and output data formats match, or 
    # course). [Something similar about responsibility and bug].

### Coping with non-relational data sources (nil, duplicates, etc.)

Before all, Alf aims at being a tool that helps you tackling practical problems
and non-normalized data is one of them. Missing values occur. Duplicates abound 
in SQL databases lacking primary keys, and so on. Using Alf's relational operators 
on such inputs is not a good idea. Not because relational theory is weak, but 
because many things becomes undefined or extremely difficult to define (try to 
extend classical algebra to define a version of +, - * and / to handle nil in 
such a way that the resulting theory is sound and still looks intuitive!). 
    
For this reason, Alf comes with a set of non-relational operators in addition
to relational ones. Those operators must be considered as "pre-relational", in
the sense that they help obtaining valid relation representations from invalid
ones. Provided that you use them correctly, their output can safely be used 
as input of a relational operator. You'll find,

* <code>alf autonum</code>  -- ensure no duplicates by generating a unique attribute
* <code>alf compact</code>  -- brute-force duplicates removal
* <code>alf defaults</code> -- replace nulls/nil by valid values, on an attribute basis

The rest is up to you.
    
## Getting started in shell

    % alf --help

The help command will display the list of available operators. Each of them is
completely described with 'alf help OPERATOR'. They all have a similar invocation
syntax in shell:

    % alf operator operands... -- args...

For example, try the following:

    # display suppliers that live in Paris
    % alf restrict suppliers -- "city == 'Paris'"
    
    # join suppliers and cities (no args here)
    % alf join suppliers cities

### Recognized data streams/files (.rash files)
    
For educational purposes, 'suppliers' and 'cities' inputs are magically resolved 
as denoting the files examples/suppliers.rash and examples/cities.rash, 
respectively. You'll find other data files: parts.rash, supplies.rash that are 
resolved magically as well and with which you can play.

A .rash file is simply a file in which each line is a ruby Hash, intended to 
represent a tuple. Under theory-driven preconditions, a .rash file can be seen
as a valid (straightforward but useful) physical representation of a relation!
When used in shell, alf dumps query results in the .rash format by default, 
which opens the ability of piping invocations! Indeed, unary operators read their 
operand on standard input if not specific as command argument. For example, the 
invocation below is equivalent to the one given above.

    # display suppliers that live in Paris
    % cat examples/suppliers.rash | alf restrict -- "city == 'Paris'"  

Similarly, when only one operand is present in invocations of binary operators, 
they read their left operand from standard input. Therefore, the join given in
previous section can also be written as follows:

    % cat examples/suppliers.rash | alf join cities

The relational algebra is _closed_ under its operators, which means that these 
operators take relations as operands and return a relation. Therefore operator 
invocations can be nested, that is, operands can be other relational expressions. 
When you use alf in a shell, it simply means that you can pipe operators as you 
want:

    % alf show --rash suppliers | alf join cities | alf restrict -- "status > 10"

### Obtaining a friendly output

The show command (which is **not** a relational operator) can be used to obtain
a more friendly output:

    # it renders a text table by default
    % alf show [--text] suppliers
    
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
    % alf restrict suppliers "city == 'Paris'" | alf show

    +------+-------+---------+-------+
    | :sid | :name | :status | :city |
    +------+-------+---------+-------+
    | S2   | Jones |      10 | Paris |
    | S3   | Blake |      30 | Paris |
    +------+-------+---------+-------+

Other formats can be obtained (see 'alf help show'). For example, you can generate
a .yaml file, as follows: 

    % alf restrict suppliers -- "city == 'Paris'" | alf show --yaml

### Executing .alf files

You'll also find .alf files in the examples folder, that contain more complex
examples in the Ruby functional syntax (see section below). 

    % cat examples/group.alf
    #!/usr/bin/env alf
    (group :supplies, [:pid, :qty], :supplying)

You can simply execute these files with alf directly as follows:

    # the following works, as well as the shortcut 'alf show group'
    % alf examples/group.alf | alf show 
    
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

    % alf -e "(restrict :suppliers, lambda{ city == 'Paris' })"

where the argument is a relational expression in Alf's Lispy dialect, which
is detailed in the next section.

## Lispy expressions

If you take a look at .alf example files, you'll find functional ruby expressions
like the following:

    % cat examples/minus.alf

    # Give all suppliers, except those living in Paris
    (minus :suppliers, 
           (restrict :suppliers, lambda{ city == 'Paris' }))
    
    # This is a contrived example for illustrating minus, as the
    # following is equivalent
    (restrict :suppliers, lambda{ city != 'Paris' })
    
You can simply execute such expressions with the alf command line itself (the 
three following invocations return the same result):
 
    % alf examples/minus.alf | alf show
    % alf show minus
    % alf -e "(restrict :suppliers, lambda{ city != 'Paris' })" | alf show

Symbols are magically resolved from the environment, which is wired to the 
examples by default. See the dedicated sections below to update this behavior
to your needs.

### Algebra is closed under its operators!

Of course, from the closure property of a relational algebra (that states that 
operators works on relations and return relations), you can use a sub expression 
*everytime* a relational operand is expected, everytime:

    # Compute the total qty supplied in each country together with the subset 
    # of products shipped there. Only consider suppliers that have a status
    # greater than 10, however.
    (summarize \
      (join \
        (join (restrict :suppliers, lambda{ status > 10 }), 
              :supplies), 
        :cities),
      [:country],
      :which => Agg::group(:pid),
      :total => Agg::sum{ qty })

Of course, complex queries quickly become unreadable that way. But you can always
split complex tasks in more simple ones using _with_:

    with( :kept_suppliers => (restrict :suppliers, lambda{ status > 10 }),
          :with_countries => (join :kept_suppliers, :cities),
          :supplying      => (join :with_countries, :supplies) ) do
      (summarize :supplying,
                 [:country],
                 :which => Agg::group(:pid),
                 :total => Agg::sum{ qty })
    end

And here is the result !

    +----------+----------+--------+
    | :country | :which   | :total |
    +----------+----------+--------+
    | England  | +------+ |   2200 |
    |          | | :pid | |        |
    |          | +------+ |        |
    |          | | P1   | |        |
    |          | | P2   | |        |
    |          | | P3   | |        |
    |          | | P4   | |        |
    |          | | P5   | |        |
    |          | | P6   | |        |
    |          | +------+ |        |
    | France   | +------+ |    200 |
    |          | | :pid | |        |
    |          | +------+ |        |
    |          | | P2   | |        |
    |          | +------+ |        |
    +----------+----------+--------+


### Going further

For now, the Ruby API is documented in the commandline help itself (a cheatsheet
or something will be provided as soon as possible). For example, you'll find the 
allowed syntaxes for RESTRICT as follows:

    % alf help restrict
    
    ...
    API & EXAMPLE
    
      # Restrict to suppliers with status greater than 20
      (restrict :suppliers, lambda{ status > 20 })
    
      # Restrict to suppliers that live in London
      (restrict :suppliers, lambda{ city == 'London' })
    ...

## Interfacing Alf in Ruby

### Calling commands 'ala' shell

For simple cases, the easiest way of using Alf in ruby is probably to mimic
what you have in shell:

    % alf restrict suppliers -- "city == 'Paris'"

Then, in ruby
    
    #
    # 1. create an engine on an environment (see section about environments later)
    # 2. run a command 
    # 3. op is a thread-safe enumerable of tuples, see the Lispy section below)
    #
    lispy = Alf.lispy(Alf::Environment.examples)
    op = lispy.run(['restrict', 'suppliers', '--', "city == 'Paris'"])

If this kind of API is not sufficiently expressive for you, you'll have to learn 
the APIs deeper, and use the Lispy functional style that Alf provides, which can
be compiled and used as explained in the next section.

### Compiling lispy expressions

If you want to use Alf in ruby directly (that is, not in shell or by executing
.alf files), you can simply compile expressions and use resulting operators as 
follows:

    # 
    # Expressions can simply be compiled as illustrated below. We use the 
    # examples environment here, see the dedicated section later about other 
    # available environments. 
    #
    lispy = Alf.lispy(Alf::Environment.examples)
    op = lispy.compile do
      (restrict :suppliers, lambda{ city == 'London' })
    end

    #
    # Returned _op_ is an enumerable of ruby hashes. Provided that datasets
    # offered by the environment (:suppliers here) can be enumerated more than 
    # once, the operator may be used multiple times and is even thread safe!
    #  
    op.each do |tuple|
      # tuple is a ruby Hash
    end

    #
    # Now, maybe you want to reuse op in a larger query, for example 
    # by projecting on the city attribute... Here is how with expressions
    # can be handled in that case
    #
    projection = lispy.with(:kept_suppliers => op) do
      (project :kept_suppliers, [:city])
    end

## Going further

### Using/Implementing other Environments

An Environment instance if passed as first argument of <code>Alf.lispy</code> 
and is responsible of resolving named datasets. A base class Environment::Folder
is provided with the Alf distribution, with a factory method on the Environment
class itself.

    env = Alf::Environment.folder("path/to/a/folder")
    
An environment built that way will look for .rash and .alf files in the specified 
folder and sub-folders. I'll of course strongly consider any contribution 
implementing the Environment contract on top of SQL or NoSQL databases or anything 
that can be useful to manipulate with relational algebra. Such contributions can 
be added to the project directly, in the lib/alf/environment folder, for example. 
A base template would look like:

    class Foo < Alf::Environment
    
      #
      # You should at least implement the _dataset_ method that resolves a 
      # name (a Symbol instance) to an Enumerable of tuples (typically a 
      # Reader). See Alf::Environment for exact contract details.
      # 
      def dataset(name)
      end
    
    end

### Adding file decoders, aka Readers

Environments should not be confused with Readers (see Reader class and its 
subclasses). While the former resolve named datasets, the latter decode files 
and/or other resources as tuple enumerables. Environments typically serve Reader
instances in response to dataset resolving.

Reader implementations decoding .rash and .alf files are provided in the main 
alf.rb file. It's relatively easy to implement the Reader contract by extending 
the Reader class and implementing an each method. Once again, contributions are 
very welcome in lib/alf/reader (.csv files, .log files, and so on). A basic 
template for this is as follows:

    class Bar < Alf::Reader
    
      #
      # You should at least implement each, see Alf::Reader which provides a 
      # base implementation and a few tools
      #
      def each
        # [...]
      end
    
      # By registering it, the Folder environment will automatically
      # recognize and decode .bar files correctly!
      Alf::Reader.register(:bar, [".bar"], self)
      
    end
  
### Adding outputters, aka Renderers

Similarly, you can contribute renderers to output relations in html, or whatever
format you would consider interesting. See the Renderer class, and consider the
following template for contributions in lib/alf/renderer

    class Glim < Alf::Renderer
    
      #
      # You should at least implement the execute method that renders tuples 
      # given in _input_ (an Enumerable of tuples) on the output buffer
      # and returns the latter. See Alf::Renderer for the exact contract 
      # details.
      #
      def execute(output = $stdout)
        # [...]
        output
      end

    
      # By registering it, the output options of 'alf show' will
      # automatically provide your --glim contribution
      Alf::Renderer.register(:glim, "as a .glim file", self)
      
    end
  
### Going even further

You know the rules: 

* The code is on github https://github.com/blambeau/alf
* Please report any problem or bug in the issues tracker on github
* Don't hesitate to fork and send me a pull request for any contribution/idea!

Last, but not least, a small tribute to Sinatra. Alf's code style is very 
inspired from what I've found in Sinatra when looking at its internals once. 
Alf, as Sinatra, is mostly implemented in a single file, lib/alf.rb. Everything 
is there but additional contributions (in lib/alf/...). You'll need an editor or 
IDE that supports code folding/unfolding. Then, follow the guide:

1. Fold everything but the Alf module.
2. Main concepts, first level of abstraction, should fit on one/two screens in height
3. Unfold the concept you're interested in, and return to the previous bullet  

Enjoy Alf!
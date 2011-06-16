# Alf

Classy data-manipulation dressed in a DSL (+ commandline)

    sudo gem install alf
    alf --help

## Links

http://github.com/blambeau/alf

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
 
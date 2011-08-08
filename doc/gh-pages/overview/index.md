## Relational Algebra at your Fingertips

Alf provides you with the relational algebra in Shell and in Ruby. It is a successful meeting between

* A sound flavor of relational algebra borrowed from The Third Manifesto and TUTORIAL D (Hugh Darwen and Chris Date);
* The pragmatism and beauty of the Ruby language (Matz);
* Functional programming
* The Open-Source Software development 

### How to install

Alf requires Ruby. We strongly recommend ruby 1.9.2, but it works with ruby 1.8.7 as well. Then,

    [sudo] gem install alf [fastercsv] [sequel] [sqlite3 pg ...]

Where 

* `fastercsv` is only required under ruby 1.8.7, if you plan to use .csv files
* `sequel` is required if you plan to connect to any SQL database
* `sqlite3`, `pg` and the like are required for connecting to a specific SQL DBMS 

### Then ?

According to your way to learn (theory or practice first?):

* [Overview](/overview/why.html) covers Alf's history and scientific background on relational theory.
* [Using Alf in Shell](/shell/index.html) is the reference guide for using Alf in Shell. It contains lots of examples.
* [Using Alf in Ruby](/ruby/index.html) is the reference guide for using Alf in Ruby. It contains lots of examples as well.


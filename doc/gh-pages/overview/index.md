## Relational Algebra at your Fingertips

Alf provides you with the relational algebra in Shell and in Ruby. It is a successful meeting between:

* A sound flavor of relational algebra borrowed from [The Third Manifesto](http://thethirdmanifesto.com) and TUTORIAL D;
* The pragmatism and beauty of the Ruby programming language;
* Open-Source Software development (MIT Licence)

### How to install

Alf requires Ruby. We strongly recommend using ruby 1.9.2. Then,

    [sudo] gem install alf [fastercsv] [sequel] [sqlite3 pg ...]

Where 

* `fastercsv` is only required under ruby 1.8.7, if you plan to use .csv files
* `sequel` is required if you plan to connect to SQL databases
* `sqlite3`, `pg` and the like are required for connecting to a specific SQL DBMS 

### Then ?

* [Overview](overview/why.html) covers Alf history and gives background on relational theory.
* [Using Alf in Shell](shell/index.html) is the reference guide for using Alf in Shell. It contains lots of examples.
* [Using Alf in Ruby](ruby/index.html) is the reference guide for using Alf in Ruby. It contains lots of examples as well.


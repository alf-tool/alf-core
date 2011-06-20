# 0.9.1 / TODO

* Enhancements

  * Reader.reader delegates to Reader.coerce when its first argument is not 
    a String. This allows calling Reader.reader(args.first || $stdin) in quickl
    commands for example.
    
* Non backward-compatible changes to public APIs

  * Lispy#chain was kept public in 0.9.0 and has been tagged as private as not
    being part of the DSL. 

* Bug fixes

  * Fixed a bug that led to an Nil error when using unary operators on $stdin
  * Fixed a bug when summarizing or sorting on Symbol attributes with ruby 1.8

# 0.9.0 / 2011.06.19

* Enhancements

  * Birthday!

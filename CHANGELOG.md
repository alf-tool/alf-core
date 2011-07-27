# 0.9.4 / FIX ME

## Enhancements to existing operators

* The DEFAULTS (non-relational) operator now accepts default values as tuple
  expressions. When used in shell, provided default values are now evaluated
  that way. In particular, this allows specifying default values as being 
  computed on the current tuple.

# 0.9.3 / 2011-07-23

## New operators (available both in shell and in Lispy DSL)

* Added MATCHING and NOT MATCHING operators. These operators are useful 
  shortcuts for the following expressions.
  
      (matching     l, r) := (project (join l, r), [l's attributes])
      (not_matching l, r) := (minus l, (matching l, r))
    
  For example: 
  
      # Give suppliers who supply at least one part
      (matching suppliers, supplies)

      # Give suppliers who don't supply any part
      (not_matching suppliers, supplies)

* Added RANK operator, which is useful for for computing quota queries as 
  illustrated below. See 'alf help rank' for details.
  
      # Give the three heaviest parts
      (restrict (rank :parts, [[:weight, :desc]], :pos), lambda{ pos < 3 })

## Enhancements when using Alf in shell

* added 'alf -r', that mimics 'ruby -r' (require library before run)

* When alf is invoked in shell (and only in this case), ALF_OPTS is used as 
  global options to apply as if they were specified inline: 
  
      % export ALF_OPTS="--env=. --yaml" 
      % alf show suppliers
      
  is the same as 
  
      % alf --env=. --yaml show suppliers
      
* 'alf --help' now distinguishes experimental operators (quota in particular) 
  from those coming from the (much more stable) TUTORIAL D specification. The 
  former should be used with care as their specification may change at any 
  time.  

## Enhancements when using Alf in Ruby 

* Alf.lispy now accepts any argument recognized by Environment.autodetect; it
  obtains its working Environment that way. Among others:
  
      Alf.lispy(Alf::Environment.folder("path/to/an/existing/folder"))
      
  is the same as: 
  
      Alf.lispy("path/to/an/existing/folder")

* Added Relation::DUM and Relation::DEE constants (relations of empty heading
  with no and one tuple, respectively). They are also available as DUM and DEE 
  in Lispy functional expressions.

* Added a Heading abstraction, as a set of attribute (name, type) pairs.

## Internal enhancements (extension points)

* The Reader and Renderer classes accept a Hash of options as third 
  constructor argument. These options can be used by extension points. 
  
* The Environment class now provides a class-based registering mechanism 'ala'
  Reader and Renderer. This allows auto-detecting the target environment when
  --env=... is used in shell. See Environment.autodetect and 
  Environment#recognizes? for contributing to this extension point. 
  
* Internals now rely on Myrrha for code generation. This means that all 
  datatypes can now be safely used in relations and dumped to .rash files in
  particular.  

## Bug fixes

* Added Relation#allbut, forgotten in two previous releases 
* Fixed (join xxx, DEE) and (join xxx, DUM)
* Fixed scoping bug when using attributes named :path, :expr or :block in
  Lispy compiled expressions (coming from .alf files)
* Fixed 'alf --yaml show suppliers' that renderer a --text table instead of
  a yaml output
* Fixed bugs when using Date and Time attributes with .rash files
* Fixed bugs when using Date and Time attributes in restrict expressions 
  compiled from the commandline
* Fixed a few bugs when using attribute names that are ruby keywords 
  (restrict & extend)  

# 0.9.2 / 2011.07.13

# Bug fixes

* Fixed the "alf show" command (undefined method `chain') 

# 0.9.1 / 2011.07.13

## Enhancements (public APIs)

* Added the in-memory Alf::Relation data structure and associated tooling.
  This allows using Alf in a object-oriented usual way, in addition to the
  functional DSL:
  
      Alf.lispy.evaluate {
        (join (restrict :suppliers, lambda{ status > 10 }), :cities)
      }
  
  is equivalent to
  
      suppliers, cities = [...], [...] 
      suppliers.restrict(lambda{ status > 10 }).join(cities)
      
  see README about how to obtain suppliers and cities relations in the first 
  place.

* Summarize now accepts a --allbut option, to specify 'by' attributes from an
  exclusion perspective

* .alf files are now evaluated in such a way that backtraces are "traceability
  friendly"

## Non backward-compatible changes to public APIs

* Lispy#with has been removed because not being stable enough. The clean way 
  of reusing sub-queries is as follows (non purely functional, so far)
  
      kept_suppliers = (restrict :suppliers, lambda{ status > 10 })
      with_countries = (join kept_suppliers, :cities)
      supplying      = (join with_countries, :supplies)
      (summarize supplying,
                 [:country],
                 :which => Agg::group(:pid),
                 :total => Agg::sum{ qty })
                 
* As a consequence, named data sources (Symbols, like :suppliers above) are 
  now resolved at compile time, which is less powerful, yet much simpler and
  sound.

* Nest and Unnest have been renamed to Wrap and Unwrap respectively. This is
  to better conform to TUTORIAL D's terminology.
  
* Lispy#chain was kept public in 0.9.0 by error and has been entirely removed 
  from the DSL.

## Enhancements (internals)

* Reader.reader delegates to Reader.coerce when its first argument is not 
  a String. This allows calling Reader.reader(args.first || $stdin) in quickl
  commands for example.
  
* Operator, Operator::Relational and Operator::NonRelational have a .each 
  class method that yields operator classes
    
## Bug fixes

* Fixed a bug that led to an Nil error when using unary operators on $stdin
* Fixed a bug when summarizing or sorting on Symbol attributes with ruby 1.8
* Fixed numerous crashes under rubinius

# 0.9.0 / 2011.06.19

## Enhancements

* Birthday!

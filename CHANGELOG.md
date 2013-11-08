# 0.15.1 / FIX ME

* Fixed Tuple(), it now accepts no argument and returns an empty tuple.
* Fixed inference of common super type when TrueClass/FalseClass/Boolean are
  involved (for Relation#heading when infered from data).
* Fixed compilation of shortcut operators involving complex expressions.
* Make Ordering#compare robust to the presence of `nil`.
* Ensured Engine::Leaf correctly symbolize tuple keys of its input operand.

# 0.15.0 / 2013-11-01

* Compiler infrastructure entirely rewritten in alf-compiler
* Changed signature of `Adapter::Connection#cog` and associated `#to_cog`
* Removed `#bind` of algebra expressions everywhere

# 0.14.0 / 01-10-2013

## Types

* Introduced Selector as an ordered list of attribute names. An Ordering is now
  a list of [Selector, (:asc|:desc)] pairs.
* Introduced Selection as an ordered list of Selectors.
* Accordingly, orderings may now include selections on tuple-valued attributes.
* Added Ordering#[] that returns the direction associated to an attribute.
* Added Ordering#reverse that reverse the direction of every attribute.
* Fixed Ordering#+ to avoid duplicate attributes. This operator is now called
  `merge` (with alias to `+`) and looks like Hash#merge, including an block to
  arbitrate conflicts.
* Removed Keys#compact which was seriously confusing.
* TupleExpression now recognizes Procs of arity 1 and simply call them with the
  tuple scope instead of `instance_exec`uting them on the scope. Predicate does
  something similar when native predicates are used.
* TupleExpression optionnaly accepts a connection argument. When the evaluated
  expression ends-up being a relational expression, the latter is evaluated on
  the connection and returns the resulting relation. TupleComputation delegates
  accordingly.

## Predicate

* Added support for qualified identifiers and Predicate#qualify.

## Support

* TupleScope now delegates to_s, inspect and [] to the underlying tuple. This
  should fix the freezing bug that occured when an error was raised during
  TupleScope-driven evaluations.
* Removed TupleScope#query and TupleScoe#tuple_extract

## Relation

* Added Relation#to_hash for getting hashes from any attribute pair.

## Viewpoint

* Added `Viewpoint.(expects,depends)` for declaring expectations and dependencies
* Added `Viewpoint.metadata` to query those expectations and dependencies
* Added `Viewpoint.build` to build viewpoints (with particular contexts)
* Removed `Viewpoint.namespace`, use `Viewpoint.depends` instead.

## Algebra

* Fixed Project#keys and Project#key_preserving? (same for Clip)
* Added `page` operator (page-index, page-size) implemented through `sort+take`
  where `take` is a new engine cog.
* Added `frame` operator (offset, limit àla SQL) implemented through `sort+take`
  as well.
* Extend now recognizes Procs of arity 1. Instead of relying on instance_exec,
  underlying expressions are evaluated by passing a TupleScope to the proc.
* Extend automatically evaluates relational expressions returned by procs,
  bounding them to the current connection if needed.

## Engine & compilation

* All engine-compiled cogs may optionally be tagged with the expression they
  come from (as taken as last argument of initialize, and readable through
  `expr`).
* The default compiler uses this feature so that algebra expressions can be
  tracked back from compilation results.

## Adapter

* Adapter::Connection#cog now takes an optional `expr` parameter for
  traceability with algebra expressions. The resulting cog is expected to be
  tagged accordingly.

## I/O

* Added a `Ruby` input reader mapping to '.rb' and '.ruby' files.
* Reader no longer includes `Engine::Cog`. `Adapter::Folder::Connection`
  correctly adapts its `cog` method to return an Engine::Leaf instance that
  delegated to the reader itself.

## Database

* The `default_viewpoint` option has been renamed `viewpoint`

# 0.13.1 / 2013-08-05

* Empty lines are silently ignored by .rash reader
* Added Viewpoint#members

# 0.13.0 / 2013-07-29

The 0.13.0 version is a new birthday for alf. See `alf` main for CHANGELOG
history.

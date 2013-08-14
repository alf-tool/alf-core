# 0.13.2 / FIX ME

* Added `Viewpoint.(expects,depends)` for declaring expectations and dependencies
* Added `Viewpoint.metadata` to query those expectations and dependencies
* Added `Viewpoint.build` to build viewpoints (with particular contexts)
* Added Ordering#[] that returns the direction associated to an attribute.
* Fixed Ordering#+ to avoid duplicate attributes. This operator is now called
  `merge` (with alias to `+`) and looks like Hash#merge, including an block to
  arbitrate conflicts.
* Added `page` operator implemented through `sort+take` where `take` is a new
  engine cog.
* Added a `Ruby` input reader mapping to '.rb' and '.ruby' files.

# 0.13.1 / 2013-08-05

* Empty lines are silently ignored by .rash reader
* Added Viewpoint#members

# 0.13.0 / 2013-07-29

The 0.13.0 version is a new birthday for alf. See `alf` main for CHANGELOG
history.

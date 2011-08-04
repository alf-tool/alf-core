## Relational basics

This page provides the necessary background on relational theory to understand Alf. Note that it only covers the concepts needed to understand the relational *algebra*; that is, nothing is said about database schemas, normal forms, transactions, ACID properties, and so on. Refer to standard database literature for those.

The background given below is a rephrasing of what can be found in The Third Manifesto (TTM), by Hugh Darwen C.J. Date. See [www.thethirdmanifesto.com](http://www.thethirdmanifesto.com), [the TTM book](http://www.amazon.com/Databases-Types-Relational-Model-3rd/dp/0321399420) or [Where does Alf come from?](/overview/where-alf-does-come-from.html).

### A theory of types

To understand what relational algebra is about, you first need to understand the underlying theory of types. Forget about object-oriented programming for a moment (if you are a developer) and remember the simple following background:

* A *type* is a (finite) **set** of values. A *subtype* is a subset. Sets are **not ordered** and have **no duplicates**.
* A *value* is an element of a type. We say that the value *belongs to* the type.
* A value is **immutable**, intrinsically **typed** [1], has no localization in time and space, and can be of arbitrary complexity.
* A type is always accompanied with an equality operator, say `==`, that allows checking if two of its elements actually denote the same value. The notion of 'duplicate' precisely relies on this operator in an obvious way.

Oh! and,

* NULL is **not** a value. Precisely, 'treating NULL as a value' on one side and 'keeping a theory simple enough to be of any practical yet sound use' on the other side are conflictual requirements. Therefore, here, NULL is not a value. 

### Tuples and Relations

... under construction ...

### Relational algebra

... under construction ...

### Footnotes

[1] even if you don't *declare* that type, it exists. So-called 'duck typing' does not mean 'types do not exists', it means 'we do not enforce them when passing arguments', roughly. 


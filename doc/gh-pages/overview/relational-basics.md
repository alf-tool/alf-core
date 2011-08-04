## Relational basics

This page provides the necessary background on relational theory to understand Alf. Note that it only covers the concepts needed to understand the relational *algebra*; that is, nothing is said about database schemas, normal forms, transactions, ACID properties, and so on. Refer to standard database literature for those.

The background given below is a rephrasing of what can be found in The Third Manifesto (TTM), by Hugh Darwen and C.J. Date. See [www.thethirdmanifesto.com](http://www.thethirdmanifesto.com), [the TTM book](http://www.amazon.com/Databases-Types-Relational-Model-3rd/dp/0321399420) or [Where does Alf come from?](/overview/where-alf-does-come-from.html).

### A theory of types

To understand what relational algebra is about, we need to briefly review a few concepts about types. Forget about object-oriented programming for a moment (if you are a developer) and examine the following definitions:

* A *type* is a (finite) **set** of values. A *subtype* is a subset. Sets are **not ordered** and have **no duplicates**.
* A *value* is an element of a type. We say that the value *belongs to* the type.
* A value is **immutable**, intrinsically **typed** [1], has no localization in time and space, and can be of arbitrary complexity.
* A type is always accompanied with an equality operator, say `==`, that allows checking if two of its elements actually denote the same value. The notion of 'duplicate' precisely relies on this operator in an obvious way.

Oh! and,

* NULL is **not** a value. Precisely, ''treating NULL as a value'' on one side and ''keeping a theory simple enough to be of any practical yet sound use'' on the other side are conflictual requirements. Therefore, here, NULL is not a value. 

#### A few examples

The simplest scalar types are well known: 

>> * (the set of) Boolean(s), Integer(s), Decimal(s), String(s), ...

There are others, of course: 

>> * (the set of) Color(s), Size(s), Weight(s), Range(s), Coordinate(s), ... 

And even a few that people don't always expect to be types: 

>> * (the set of) List(s), Set(s), Tree(s), Graph(s), ...

Roughly, surrounding a set of immutable elements for which an equality operator makes sense *is* defining a type. Implementing it is another story, of course. 

### Tuples and Relations

Tuples and relations are values as well. In contrast to integers or strings however, tuples and relations are not scalar; they have an internal ''structure''. Apart from that, they are values and they have a type. Let's have a closer look at that.

#### Tuple

* A *tuple* is a set of attribute (name, value) pairs. It is such that no two pairs have the same name.
* A tuple being a set, it is not particularly ordered.
* A tuple being a value, it is immutable.

We will denote tuple literals as follows (we assume that a Color type exists):

<pre class="theory"><code class="ruby">#
# The product whose id is 'P3',
#  * is named 'Screw', 
#  * has a color denoted by 'blue', and 
#  * is known to be heavy.
#
Tuple( pid: 'P1', name: 'Nut', color: Color('red'), heavy: true )
</code></pre>

<p class="note">Alf uses Ruby Hashes for implementing tuples. The example above is syntaxtically correct in Ruby 1.9.x and returns a Hash when usign Alf. Of course, there are hashes that do not implement valid tuples (those containing nil, for example). Alf assumes that you use them in accordance with this background (in an immutable way, among others); it does **not** systematically enforce this precondition. It's up to you to use Alf the correct way.<p>

The type of a tuple is simply defined in terms of its heading. A *heading* is defined as a set of attribute (name, type name) pairs. For example, the heading of the tuple show above is:

<pre class="theory"><code class="ruby">Heading( pid: String, name: String, color: Color, heavy: Boolean )</code></pre>

<p class="note">Alf assumes that types are implemented with Ruby classes. String, Color and Boolean are all valid class names in Ruby, though it's worth noting that the Boolean class does not natively exists. As it is of huge importance for Alf, it defines it in such a way that everything looks fine. The Color class is assumed here to be a user-defined class. Not all user-defined classes implement valid types. Alf assumes that you use them in accordance with this background; it does **not** systematically enforce this precondition. It's up to you to use Alf the correct way.<p>

#### Relation

* A *relation* is a set of tuples of same heading
* A relation being a set, it is not particularly ordered and does not have duplicates.
* A relation being a value, it is immutable.

We will denote relation literals as follows:

<pre class="theory"><code class="ruby">Relation(
  Tuple( pid: 'P1', name: 'Nut',   color: Color('red'),   heavy: true  ),
  Tuple( pid: 'P2', name: 'Bolt',  color: Color('green'), heavy: false ),
  Tuple( pid: 'P3', name: 'Screw', color: Color('blue'),  heavy: false )
)</code></pre>

<p class="note">The example above is syntaxtically correct in Alf and returns a relation data structure. Alf support other ways of obtaining relations than literals. Among others, it recognizes different data sources, like .csv files or SQL tables. In any way, Alf assumes that you use relations in accordance with this background; it does **not** systematically enforce this precondition. It's up to you to use Alf the correct way.<p>

The type of a relation is simply defined in terms of its heading. For example, the heading of the relation show above is:

<pre class="theory"><code class="ruby">Heading( pid: String, name: String, color: Color, heavy: Boolean )</code></pre>

### Relational algebra

... under construction ...

### Footnotes

[1] even if you don't *declare* that type, it exists. So-called 'duck typing' does not mean 'types do not exists', it means 'we do not enforce them when passing arguments', roughly. 


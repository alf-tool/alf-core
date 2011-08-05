## One proposal, three flavors

As I explain [here](/overview/where-does-alf-come-from.html), I've started Alf because I wanted to split the effective execution of benchmarks from the summarization and displaying of their results. It has been written with a strong background about relational theory, so that it ends up being actually a proposal of query language plus an implementation supporting three syntactic flavors.

### Overview

Our query language proposal is not about the semantics of relational algebra, which is borrowed from [The Third Manifesto and TUTORIAL D](http://thethirdmanifesto.com/). Instead, it is about syntactic issues and a few suggestions for using relational algebra in dynamic languages like python, ruby, clojure, javascript and the like. We call the latter the "hosting language" below. Specifically, we propose

* a list of *named relational operators* together with their *signature* in terms of *operands*, *arguments* and *options*
* a specification of the *types* of arguments and options

Note that, this is neither purely semantic nor purely syntactic and should be seen as a definition of an abstract Domain Specific Language (DSL) [1, 2]. Alf provides three syntactic flavors of this DSL (one for expressing queries in shell, two others for expressing queries in Ruby) and an execution engine. Note that,

* as such, the query language **says nothing about how** queries are executed. Alf's engine is a pragmatic reference implementation that tries not to load whole relations in memory, where possible [3].
* the boundaries of the proposed query language are intentionally limited to avoid perturbating the hosting language with concepts that would make it impossible to implement [4].
* in particular, it does not prescribe a predefined set of supported scalar types and operators. Most hosting languages support Boolean, Integer or String, etc. and provides users with ways for implementing new ones.

### Basic types

This section describes the basic types used in query expressions. The proposal **does not prescribe any dedicated syntax for literals**, that must be made clear by each DSL implementation. Examples below are valid literals when using the functional Ruby DSL of Alf. 

#### Name

A name is used to denote base relations, attributes and types. When relevant, the context distinguish between attribute names, relation names and type names. Examples are:

<pre class="theory"><code class="ruby">:suppliers, :parts             # relation names
:name, :city, :color_in_rgb    # attribute names
String, Float, Color           # type names
</code></pre>

#### Attribute list

An attribute list is simply a list of attribute *names*. Such a list has a left-to-right ordering which may or may not be relevant in the context of its use. Generally, duplicates in attributes lists does not make sense. Examples of attribute lists are:

<pre class="theory"><code class="ruby">[]                      # the empty list
[:name]                 # the singleton list
[:name, :city, :color]  # general case
</code></pre>

#### Renaming

A renaming is a mapping between attribute names and other attribute names (a partial function, in fact). Examples of renaming are:

<pre class="theory"><code class="ruby">{}                                                  # the empty renaming
{:name => :supplier_name}                           # a singleton renaming
{:name => :supplier_name, :color => :color_in_rgb}  # a more general case
</code></pre>

#### Heading

A heading is a mapping between attribute names and type names (a partial function, in fact). Examples of headings are:

<pre class="theory"><code class="ruby">{}                                  # the empty heading
{:name => String}                   # a singleton heading
{:name => String, :color => Color}  # a more general case
</code></pre>

#### Order direction and Ordering

An order direction is simply ascending or descending. In the ruby DSL:

<pre class="theory"><code class="ruby">:asc, :desc</code></pre>

An ordering is a ordered mapping between attribute names and order directions. To stress the fact that an ordering is itself *ordered* (unlike a heading or a renaming), the idiomatic way of expressing orderings in the ruby DSL is as follows: 

### References and footnotes

1. Arie van Deursen, Paul Klint, and Joost Visser. *Domain-specific languages: an annotated bibliography*. ACM SIGPLAN Vol 35., pages 26-36, June 2000.
2. Martin Fowler, *Domain Specific Languages*, Addison-Wesley Professional, 1st edition, 2010.
3. You are absolutely free to implement it on distributed cloud architectures involving NoSQL and map/reduce technologies if it makes sense.
4. Therefore, it is **not an attempt to standardize** a query language but rather the pragmatic suggestion of "using similar names and structure for similar concepts in different contexts", hence the DSL approach.


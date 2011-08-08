## One proposal, three flavors

Alf supports three syntactic flavors of relational algebra: one to use Alf in shell, two others to use it in Ruby (one with a functional style and an object-oriented one). This page summarizes the common parts in terms of:

* a list of *named relational operators* together with their *signature* in terms of *operands*, *arguments* and *options*
* a specification of the *types* of arguments and options

Note that, this is neither purely semantic nor purely syntactic. It should better be seen as a definition of an abstract Domain Specific Language (DSL) [1, 2] for which Alf provides three syntactic implementations. Note that,

* as such, the DSL **says nothing about how** queries are executed. The Alf engine is a pragmatic implementation that tries not to load whole relations in memory, where possible. [3]
* the boundaries of the DSL are intentionally limited to avoid perturbating implementations with concepts that would make it impossible to implement. The aim here is to set a basis that could be ported without much effor to other dynamic languages such as clojure, python, javascript, and so on. [4] 
* in particular, it does not prescribe a predefined set of supported scalar types and operators. Most implementation languages support Boolean, Integer or String, etc. and provides users with ways for implementing new ones.

### Basic types

This section describes the basic types used in query expressions. Note that it does not prescribe any dedicated syntax for literals, that are implementation specific. Examples below are valid literals when using the functional Ruby DSL of Alf. 

#### Name

A name is used to denote base relations, attributes and types. When relevant, the context distinguishes between attribute names, relation names and type names. Examples are:

<pre class="theory"><code class="ruby">:suppliers, :parts             # relation names
:name, :city, :color_in_rgb    # attribute names
String, Float, Color           # type names
</code></pre>

#### Attribute list

An attribute list is simply a list of attribute *names*. Such a list has a left-to-right ordering whose relevance is context specific. Generally, attribute lists have no duplicates. Examples of attribute lists are:

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

<pre class="theory"><code class="ruby">[]                                  # the empty ordering
[[:name, :asc]]                     # name, in ascending order
[[:name, :asc], [:city, :desc]]     # name in ascending order, then city in descending order
</code></pre>

As full ascending orders are commonly used, the following shortcuts are also supported:

<pre class="theory"><code class="ruby">[:name]                             # name, in ascending order
[:name, :city]                      # name in ascending order, then city in ascending order as well
</code></pre>

#### Tuple expression

A tuple expression is an expression evaluated in the context/scoping of a tuple. The DSL does not prescribe what forms a valid expression, which is implementation specific. We assume purely functional expressions, since the affectation is useless when considering relational algebra in isolation.

In ruby DSL, Alf uses lambda functions for tuple expressions. For example:

<pre class="theory"><code class="ruby">->(){ true }                        # expression that always evaluates to true
->(){ qty * price }                 # `qty` and `price` denote tuple attributes
</code></pre>

#### Tuple predicate

A tuple predicate is a tuple expression which returns a Boolean value. For example:

<pre class="theory"><code class="ruby">->(){ true }                        # the `true` predicate
->(){ qty > 100 }                   # `qty` denotes a tuple attribute
</code></pre>

#### Tuple computation

A tuple computation is a mapping between attribute names and tuple expressions (a partial function, in fact). For example:

<pre class="theory"><code class="ruby">
{}                                                         # the empty computation
{:total => ->(){ qty * price }}                            # a singleton computation
{:big => ->{ qty > 100 }, :total => ->(){ qty * price }}   # a general case
</code></pre>

#### Summarizing expression

### References and footnotes

1. Arie van Deursen, Paul Klint, and Joost Visser. *Domain-specific languages: an annotated bibliography*. ACM SIGPLAN Vol 35., pages 26-36, June 2000.
2. Martin Fowler, *Domain Specific Languages*, Addison-Wesley Professional, 1st edition, 2010.
3. You are absolutely free to implement it on distributed cloud architectures involving NoSQL and map/reduce technologies if it makes sense.
4. Therefore, it is **not an attempt to standardize** a query language but rather the pragmatic suggestion of "using similar names and structure for similar concepts in different contexts", hence the DSL approach.


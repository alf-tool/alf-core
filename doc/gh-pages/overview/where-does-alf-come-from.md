## Where does Alf come from ?

I wrote my master thesis in 2002-2003; it was already about object-relational mapping (ORM) and the so-called "impedence mismatch" between object-oriented programming languages and relational databases. At that time, Hibernate was not yet the de-facto mapper in the Java world, Rails/ActiveRecord did not even exist and the associated pattern, by Martin Fowler, just appeared.

My father suggested the reading of The Third Manifesto ([the book](http://www.amazon.com/Databases-Types-Relational-Model-3rd/dp/0321399420), first edition, by Hugh Darwen and C.J. Date), which quickly appeared to me as conveying some kind of "scientific truth" about the topic. Roughly, ORMs prone the horizontal decomposition of types in SQL tables (class = table) where a sound analysis would quickly lead considering a vertical decomposition as the sound way to go (class = domain); doing so would require proper support for user-defined types, that SQL does not have (among numerous other defects).

I've spent the next years reading about Date and Darwen's Dream (having a truly relational language, called a "D", as a drop-in replacement for SQL; a far broader topic than the ORM stuff, I must add), reading most of their books and enjoying their research. During the same years, I've seen the advent of object-relational mapping, I've known people killing their architecture, arbitrarily restricting their query abilities, hurting scalability,... I've repaired numerous databases built by developers who sincerely think that "constraints must be checked at the application level" but who, at the same time, write buggy applications (like all of us) and bypass the "application level" for specific needs. I've also heard about numerous attempts to "replace the relational model by something more powerful", often XML, Objects, Web semantics and NoSQL solutions... without much success so far.

I've been tempted to start the implementation of such a "D" language many times. My rather limited low-level programming skills have always cooled me. Implementing a D is a huge task, which deserves and requires talented developers with strong language design and implementation skills... that I simply don't have myself.

So, I've been waiting; [Blogging a bit](http://revision-zero.org/logical_data_independence) about database-related stuff; Reading and participating to discussions about TTM and D; Sometimes writing [TTM-inspired libraries](http://github.com/blambeau) and other software pieces; and so on.

... To be continued ...

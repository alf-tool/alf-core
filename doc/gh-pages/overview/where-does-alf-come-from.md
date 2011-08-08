## Where does Alf come from ?

I wrote my master thesis in 2002-2003, on object-relational mapping (ORM) and the so-called "impedence mismatch" between object-oriented programming languages and relational databases. At that time, Hibernate was not yet the de-facto mapper in the Java world, Rails/ActiveRecord did not even exist and the associated pattern, by Martin Fowler, just appeared.

For that work, my father suggested the reading of The Third Manifesto ([the book](http://www.amazon.com/Databases-Types-Relational-Model-3rd/dp/0321399420), first edition, by Hugh Darwen and C.J. Date), which quickly appeared to me as conveying some kind of "scientific truth" about the topic. Roughly, ORMs prone the horizontal decomposition of types in SQL tables (class = table) where a sound analysis quickly leads considering a vertical decomposition as the sound way to go (class = domain); the latter would require proper support for user-defined types, that SQL does not have.

I've spent years hoping for Date and Darwen's dream to become a reality. I've continued to read their books, and enjoyed their research and writings. 

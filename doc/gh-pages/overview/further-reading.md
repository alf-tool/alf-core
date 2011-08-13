## Further reading

Alf is much inspired by *The Third Manifesto* (TTM) and **Tutorial D**. In essence, 

* TTM is a paper submitted by Hugh Darwen and C.J. Date to ACM Sigmod Record in 1995. It is a manifesto for the future direction of data and database management systems; it was submitted in response to two previous "manifesto" papers that the authors felt inadequate, not to say wrong.
* The TTM paper has been followed by the TTM book. [The third edition](http://books.google.com/books/about/Databases_types_and_the_relational_model.html?id=X85QAAAAMAAJ) is entitled "Databases, types and the relational model" and gives a long and rather technical explanation of the ideas underlying the TTM paper.
* The TTM defines a series of prescriptions, proscriptions and very strong suggestions for the design of a truly-relational database language, called a "D", as a drop-in replacement for SQL and its numerous flaws. It also defines a formal type system, supporting sub-typing through specialization-by-constraint. This proposal is rather technical, but a very good reading for every computer scientist and computer professional.
* **Tutorial D** is such a "D", used for educational purposes in database books by C.J. Date and Hugh Darwen. Most relational operators of Alf are borrowed from **Tutorial D**.

If you do not know this technical background, I would strongly suggest reading one of the following books. They are far more accessible than the TTM book itself and cover the necessary background to understand where Alf comes from:

* [Database in depth: relational theory for practitioners](http://books.google.com/books?id=FU7uuHc3oNcC&source=gbs_similarbooks), C.J. Date, O'Reilly Media, Inc., 2005
* [An Introduction to Relational Database Theory](http://bookboon.com/uk/textbooks/it/an-introduction-to-relational-database-theory), Hugh Darwen, Book Boon, 2010

### Related projects and links

* *The Third Manifesto* has a [dedicated website](http://thethirdmanifesto.com/) and a mailing list where TTM-related topics are discussed with the TTM authors, database researchers, professionals and practioners as well as TTM-related project developers.
* [Rel](http://dbappbuilder.sourceforge.net/Rel.php) is an implementation of **Tutorial D** (the very first one, and the most complete), written in Java, that can be used for learning, teaching, and exploring relational database concepts. 
* Greg Gaughan's [Dee](http://www.quicksort.co.uk/) project is similar to Alf, but anterior and written in Python. Don't forget to have a look at it if you prefer Python to Ruby!
* Dan Kubb's [Veritas](https://github.com/dkubb/veritas) ruby library project is worth looking at in the Ruby community. While being very similar to Alf in providing a pure ruby algebra implementation, Veritas mostly provides a framework for manipulating and statically analyzing algebra expressions so as to be able to [optimize them](https://github.com/dkubb/veritas-optimizer) and [compile them to SQL](https://github.com/dkubb/veritas-sql-generator). We are working together with Dan Kubb to see how Alf and Veritas could be brought closer together in the future, if not in their codebase, at least in having a common basis in terms of terminology and API.
* Other implementation projects [can be found here](http://www.dcs.warwick.ac.uk/~hugh/TTM/Projects.html).

